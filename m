From: "Javali, Nilesh" <Nilesh.Javali@cavium.com>
Subject: Re: [PATCH] scsi/qla4: comments correction
Date: Thu, 22 Dec 2016 11:34:35 +0000
Message-ID: <D481B7C0.43953%nilesh.javali@cavium.com>
References: <1482128429-17975-1-git-send-email-caoj.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0053.outbound.protection.outlook.com ([104.47.38.53]:16704
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754241AbcLVLtt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 06:49:49 -0500
In-Reply-To: <1482128429-17975-1-git-send-email-caoj.fnst@cn.fujitsu.com>
Content-Language: en-US
Content-ID: <3226E286A0CF9847B77700FD5AC2C7E3@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Cao jin <caoj.fnst@cn.fujitsu.com>, "QLogic-Storage-Upstream@qlogic.com" <QLogic-Storage-Upstream@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>



On 19/12/16, 11:50 AM, "linux-scsi-owner@vger.kernel.org on behalf of Cao
jin" <linux-scsi-owner@vger.kernel.org on behalf of
caoj.fnst@cn.fujitsu.com> wrote:

>Signed-off-by: Cao jin <caoj.fnst@cn.fujitsu.com>
>---
> drivers/scsi/qla4xxx/ql4_os.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
>index 01c3610a60cf..fc60e0a1043e 100644
>--- a/drivers/scsi/qla4xxx/ql4_os.c
>+++ b/drivers/scsi/qla4xxx/ql4_os.c
>@@ -9546,15 +9546,15 @@ static int qla4xxx_host_reset(struct Scsi_Host
>*shost, int reset_type)
>  * driver calls the following device driver's callbacks
>  *
>  * - Fatal Errors - link_reset
>- * - Non-Fatal Errors - driver's pci_error_detected() which
>+ * - Non-Fatal Errors - driver's error_detected() which
>  * returns CAN_RECOVER, NEED_RESET or DISCONNECT.
>  *
>  * PCI AER driver calls
>- * CAN_RECOVER - driver's pci_mmio_enabled(), mmio_enabled
>+ * CAN_RECOVER - driver's mmio_enabled(), mmio_enabled()
>  *               returns RECOVERED or NEED_RESET if fw_hung
>  * NEED_RESET - driver's slot_reset()
>  * DISCONNECT - device is dead & cannot recover
>- * RECOVERED - driver's pci_resume()
>+ * RECOVERED - driver's resume()
>  */
> static pci_ers_result_t
> qla4xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t
>state)
>--=20
>2.1.0

Acked-by: Nilesh Javali <nilesh.javali@cavium.com>

