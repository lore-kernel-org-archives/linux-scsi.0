From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 0/13] scsi: arcmsr: add some driver options and support new
 adapter ARC-1884
Date: Thu, 09 Nov 2017 07:37:59 +0800
Message-ID: <1510184279.4523.60.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, dan.carpenter@oracle.com, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Hi all,

The following patches apply to Martin's 4.15/scsi-queue.

Patch 1: redefine ACB_ADAPTER_TYPE_A, _B, _C, _D and subsequent changes.

Patch 2: simplify arcmsr_iop_init function.

Patch 3: add codes for ACB_ADAPTER_TYPE_E to support new adapter ARC-1884

Patch 4: replace constant ARCMSR_MAX_FREECCB_NUM by variable acb->maxFreeCCB that was got from firmware.

Patch 5: add driver option host_can_queue to set host->can_queue value by user. It's value expands
         up to 1024.

Patch 6: replace constant ARCMSR_MAX_OUTSTANDING_CMD by variable acb->maxOutstanding that was determined by user.

Patch 7: add driver option cmd_per_lun to set host->cmd_per_lun value by user.

Patch 8: add ACB_F_MSG_GET_CONFIG to acb->acb_flags for for message interrupt checking before schedule work for
         get device map.

Patch 9: add a function arcmsr_set_iop_datetime and driver option set_date_time to set date and time to firmware.

Patch 10: fix clear doorbell queue on ACB_ADAPTER_TYPE_B controller.

Patch 11: spin off duplicate code of timer init for message isr BH in arcmsr_probe and arcmsr_resume as a function
          arcmsr_init_get_devmap_timer

Patch 12: adjust some tab or white-space to make text alignment.

Patch 13: update driver version to v1.40.00.02-20171011

Please review. Thanks.

---
