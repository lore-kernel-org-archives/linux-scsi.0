From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 0/3] scsi: arcmsr: Add driver parameter cmd_timeout for
 scsi command timeout setting
Date: Mon, 07 May 2018 14:43:21 +0800
Message-ID: <1525675401.8876.9.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

>From Ching Huang <ching2048@areca.com.tw>

This patch series are against to mkp's 4.18/scsi-queue.

1. Add driver parameter cmd_timeout, default value is ARCMSR_DEFAULT_TIMEOUT.
2. Add slave_configure callback function to set device command timeout value.
3. Update driver version to v1.40.00.06-20180504.

--
