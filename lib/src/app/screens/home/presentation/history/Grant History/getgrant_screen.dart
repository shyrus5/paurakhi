import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paurakhi/src/core/API/Grant%20History/grant_history.dart';
import 'package:paurakhi/src/core/themes/appcolors.dart';
import 'package:paurakhi/src/core/themes/appstyles.dart';

import 'getgrant_model.dart';

class GrantHistoryController extends GetxController {
  final RxList<Datums> quotationHistoryList = <Datums>[].obs;
  final RxBool isLoading = false.obs;
  int page = 1;

  @override
  void onInit() {
    super.onInit();
    fetchQuotationHistory();
  }

  Future<void> fetchQuotationHistory() async {
    if (!isLoading.value) {
      isLoading.value = true;
      final GrantHistoryModel? quotationHistory =
          await GetGrantHistory.grantHistory(page);
      if (quotationHistory != null && quotationHistory.data.isNotEmpty) {
        quotationHistoryList.addAll(quotationHistory.data);
        page++; // Increment the page for the next API call
      }
      isLoading.value = false;
    }
  }

  Future<void> loadGrantHistory() async {
    page = 1;
    quotationHistoryList.clear();
    if (!isLoading.value) {
      isLoading.value = true;
      final GrantHistoryModel? quotationHistory =
          await GetGrantHistory.grantHistory(1);
      if (quotationHistory != null && quotationHistory.data.isNotEmpty) {
        quotationHistoryList.addAll(quotationHistory.data);
        print(page);
      }
      isLoading.value = false;
    }
  }
}

void getGrantScreen(BuildContext context) {
  final GrantHistoryController controller = Get.put(GrantHistoryController());

  showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
    ),
    builder: (BuildContext context) {
      return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                      child:
                          Text("Grant History", style: AppStyles.text22PxBold)),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Obx(
                    () {
                      if (controller.quotationHistoryList.isEmpty &&
                          controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      } else if (controller.quotationHistoryList.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 30),
                              const Icon(
                                Icons.info_rounded,
                                size: 60,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 30),
                              Text(
                                "No history found!",
                                style: AppStyles.text18PxMedium,
                              ),
                            ],
                          ),
                        );
                      } else {
                        final bool isLoadMoreVisible =
                            controller.quotationHistoryList.length > 9;
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    controller.quotationHistoryList.length + 1,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index <
                                      controller.quotationHistoryList.length) {
                                    final Datums datum =
                                        controller.quotationHistoryList[index];
                                    return historyWidget(datum.title,
                                        datum.status, datum.createdAt);
                                  } else if (controller.isLoading.value) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                          color: AppColors.primary),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            ),
                            if (isLoadMoreVisible &&
                                !controller.isLoading.value)
                              GestureDetector(
                                onTap: () {
                                  Get.find<GrantHistoryController>().page++;

                                  controller.fetchQuotationHistory();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'Load More',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ));
    },
  );
}

SizedBox historyWidget(product, status, price) {
  return SizedBox(
    height: 100,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0.5,
      child: Column(
        children: [
          const SizedBox(height: 10),
          ListTile(
            title: Text("$product", style: AppStyles.text20PxBold),
            trailing: status == "pending"
                ? Icon(Icons.format_align_center_rounded,
                    size: 30, color: Colors.green[200])
                : status == "close"
                    ? const Icon(Icons.format_align_center_rounded,
                        size: 30, color: Colors.green)
                    : status == "unsolved"
                        ? const Icon(Icons.format_align_center_rounded,
                            size: 30, color: Colors.grey)
                        : const Icon(Icons.format_align_center_rounded,
                            size: 30, color: Colors.red),
            subtitle:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 4),
              Text("Date: $price"),
            ]),
          ),
        ],
      ),
    ),
  );
}
