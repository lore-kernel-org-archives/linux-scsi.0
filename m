From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH] [trivial] [resend] [SCSI] qla4xxx: Add missing spaces
 to error messages
Date: Mon, 27 Feb 2012 01:23:40 -0800
Message-ID: <CB714933.CF07%vikas.chaudhary@qlogic.com>
References: <1330097579-25679-1-git-send-email-petr.uzel@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1330097579-25679-1-git-send-email-petr.uzel@suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Petr Uzel <petr.uzel@suse.cz>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ravi Anand <ravi.anand@qlogic.com>, Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Jiri Kosina <trivial@kernel.org>, scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

-----Original Message-----
From: Petr Uzel <petr.uzel@suse.cz>
Date: Fri, 24 Feb 2012 07:32:59 -0800
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ravi Anand <ravi.anand@qlogic.com>, Vikas Chaudhary
<vikas.chaudhary@qlogic.com>, Dept-Eng iSCSI Driver
<Dept-iSCSIDriver@qlogic.com>, "James E.J. Bottomley"
<JBottomley@parallels.com>, Jiri Kosina <trivial@kernel.org>, scsi
<linux-scsi@vger.kernel.org>
Subject: [PATCH] [trivial] [resend] [SCSI] qla4xxx: Add missing spaces to
error messages

>
>Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
>---
> drivers/scsi/qla4xxx/ql4_os.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
>index ce6d3b7..edf5034 100644
>--- a/drivers/scsi/qla4xxx/ql4_os.c
>+++ b/drivers/scsi/qla4xxx/ql4_os.c
>@@ -3382,7 +3382,7 @@ static int get_fw_boot_info(struct scsi_qla_host
>*ha, uint16_t ddb_index[])
>               if (qla4xxx_get_flash(ha, buf_dma, addr,
>                                     13 * sizeof(uint8_t)) != QLA_SUCCESS) {
>                       DEBUG2(ql4_printk(KERN_ERR, ha, "scsi%ld: %s: Get Flash"
>-                                        "failed\n", ha->host_no, __func__));
>+                                        " failed\n", ha->host_no, __func__));
>                       ret = QLA_ERROR;
>                       goto exit_boot_info_free;
>               }
>@@ -3620,7 +3620,7 @@ static int qla4xxx_setup_boot_info(struct
>scsi_qla_host *ha)
>
>       if (ql4xdisablesysfsboot) {
>               ql4_printk(KERN_INFO, ha,
>-                         "%s: syfsboot disabled - driver will trigger login"
>+                         "%s: syfsboot disabled - driver will trigger login "
>                          "and publish session for discovery .\n", __func__);
>               return QLA_SUCCESS;
>       }
>--
>1.7.7

Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
