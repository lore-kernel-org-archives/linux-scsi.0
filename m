From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 2/2] scsi: qla2xxx: print MAC via %pMR
Date: Thu, 26 Jul 2012 08:23:00 -0400
Message-ID: <alpine.WNT.2.00.1207260822340.4880@N5102REMCQXM4BS.qlogic.org>
References: <1342079490-20191-1-git-send-email-andriy.shevchenko@linux.intel.com> <1342079490-20191-2-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.199.154.207] ([213.199.154.207]:43223 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751266Ab2GZMYJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2012 08:24:09 -0400
In-Reply-To: <1342079490-20191-2-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>



On Thu, 12 Jul 2012, Andy Shevchenko wrote:

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> drivers/scsi/qla2xxx/qla_attr.c |    5 +----
> 1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index 5ab9530..095ba85 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1193,10 +1193,7 @@ qla2x00_vn_port_mac_address_show(struct device *dev,
>       if (!IS_CNA_CAPABLE(vha->hw))
>               return snprintf(buf, PAGE_SIZE, "\n");
>
> -     return snprintf(buf, PAGE_SIZE, "%02x:%02x:%02x:%02x:%02x:%02x\n",
> -         vha->fcoe_vn_port_mac[5], vha->fcoe_vn_port_mac[4],
> -         vha->fcoe_vn_port_mac[3], vha->fcoe_vn_port_mac[2],
> -         vha->fcoe_vn_port_mac[1], vha->fcoe_vn_port_mac[0]);
> +     return snprintf(buf, PAGE_SIZE, "%pMR\n", vha->fcoe_vn_port_mac);
> }
>
> static ssize_t
>

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

