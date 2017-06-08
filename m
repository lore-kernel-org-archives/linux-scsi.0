From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/7] scsi: ibmvscsi_tgt: remove use of class_attrs
Date: Thu, 8 Jun 2017 07:31:43 -0500
Message-ID: <2a7a2937-9f0e-de01-1690-21cf92bb45f2@linux.vnet.ibm.com>
References: <20170608081242.27061-1-gregkh@linuxfoundation.org>
 <20170608081242.27061-3-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170608081242.27061-3-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Cc: Michael Cyr <mikecyr@linux.vnet.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


> The class_attrs pointer is going away and it's not even being used in
> this driver, so just remove it entirely.
>
> Cc: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
> Cc: Michael Cyr <mikecyr@linux.vnet.ibm.com>
> Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: <linux-scsi@vger.kernel.org>
> Cc: <target-devel@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 5 -----
>   1 file changed, 5 deletions(-)
>
> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> index d390325c99ec..b480878e3258 100644
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -3915,10 +3915,6 @@ static const struct target_core_fabric_ops ibmvscsis_ops = {
>
>   static void ibmvscsis_dev_release(struct device *dev) {};
>
> -static struct class_attribute ibmvscsis_class_attrs[] = {
> -	__ATTR_NULL,
> -};
> -
>   static struct device_attribute dev_attr_system_id =
>   	__ATTR(system_id, S_IRUGO, system_id_show, NULL);
>
> @@ -3938,7 +3934,6 @@ ATTRIBUTE_GROUPS(ibmvscsis_dev);
>   static struct class ibmvscsis_class = {
>   	.name		= "ibmvscsis",
>   	.dev_release	= ibmvscsis_dev_release,
> -	.class_attrs	= ibmvscsis_class_attrs,
>   	.dev_groups	= ibmvscsis_dev_groups,
>   };
>
Thanks Greg, ACK.

-Bryant
