From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [patch] [SCSI] qla4xxx: silence a Sparse warning
Date: Tue, 21 Feb 2012 05:24:57 -0800
Message-ID: <CB69987C.CCEC%vikas.chaudhary@qlogic.com>
References: <20120221073011.GC6896@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:33991
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753804Ab2BUNZG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2012 08:25:06 -0500
In-Reply-To: <20120221073011.GC6896@elgon.mountain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Ravi Anand <ravi.anand@qlogic.com>
Cc: Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

-----Original Message-----
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 20 Feb 2012 23:30:12 -0800
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Dept-Eng iSCSI Driver
<Dept-iSCSIDriver@qlogic.com>, "James E.J. Bottomley"
<JBottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>,
"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: [patch] [SCSI] qla4xxx: silence a Sparse warning

>Sparse complains that the definition of this funciton doesn't match the
>implementation.  The "uint32_t aen_code" should be an enum.
>
>drivers/scsi/qla4xxx/ql4_os.c:2966:5: error: symbol
>       'qla4xxx_post_aen_work' redeclared with different type
>       (originally declared at drivers/scsi/qla4xxx/ql4_glbl.h:184)
>       - incompatible argument 2 (different signedness)
>
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
>diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h
>b/drivers/scsi/qla4xxx/ql4_glbl.h
>index 954ba91..71bbc07 100644
>--- a/drivers/scsi/qla4xxx/ql4_glbl.h
>+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
>@@ -181,7 +181,8 @@ int qla4xxx_flash_ddb_change(struct scsi_qla_host
>*ha, uint32_t fw_ddb_index,
> int qla4xxx_ddb_change(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
>                      struct ddb_entry *ddb_entry, uint32_t state);
> void qla4xxx_build_ddb_list(struct scsi_qla_host *ha, int is_reset);
>-int qla4xxx_post_aen_work(struct scsi_qla_host *ha, uint32_t aen_code,
>+int qla4xxx_post_aen_work(struct scsi_qla_host *ha,
>+                        enum iscsi_host_event_code aen_code,
>                         uint32_t data_size, uint8_t *data);
> int qla4xxx_ping_iocb(struct scsi_qla_host *ha, uint32_t options,
>                     uint32_t payload_size, uint32_t pid, uint8_t *ipaddr);

Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

