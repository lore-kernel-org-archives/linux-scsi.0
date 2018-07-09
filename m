From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 0/2] scsi: arcmsr: fix error of resuming from hibernation
Date: Mon, 09 Jul 2018 18:19:28 +0800
Message-ID: <1531131568.5779.8.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

This patch series are against to mkp's 4.19/scsi-queue.

1. Fix error of resuming from hibernation for adapter type E.
2. Update driver version to v1.40.00.09-20180709

---
