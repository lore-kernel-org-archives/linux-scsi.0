From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 0/4] scsi: arcmsr: Support Areca thunderbolt devices
 hot-plug
Date: Thu, 15 Mar 2018 14:25:29 +0800
Message-ID: <1521095129.31371.25.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

This patch series are against to mkp's 4.17/scsi-queue.

1. Rename ACB_F_BUS_HANG_ON to ACB_F_ADAPTER_REMOVED for adapter hot-plug
2. Handle adapter removed due to thunderbolt cable disconnection.
3. Sleep to avoid CPU stuck too long for waiting adapter ready
4. Change driver version to v1.40.00.05-20180309

---
