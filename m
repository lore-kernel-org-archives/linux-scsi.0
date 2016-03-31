From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 5/5] scsi_transport_iscsi: Declare local symbols static
Date: Thu, 31 Mar 2016 10:03:57 +0200
Message-ID: <fc5e0cefaa50d061ed172cdeb12440c3@suse.de>
References: <56FC1A3B.4040704@sandisk.com> <56FC1ABB.8050501@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbcCaID7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 04:03:59 -0400
In-Reply-To: <56FC1ABB.8050501@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2016-03-30 20:28, Bart Van Assche wrote:
> Avoid that building with W=1 causes gcc to report warnings about
> symbols that have not been declared.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c
> b/drivers/scsi/scsi_transport_iscsi.c
> index dff7413..c169fa1 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1009,7 +1009,7 @@ static void iscsi_flashnode_sess_release(struct
> device *dev)
>  	kfree(fnode_sess);
>  }
> 
> -struct device_type iscsi_flashnode_sess_dev_type = {
> +static struct device_type iscsi_flashnode_sess_dev_type = {
>  	.name = "iscsi_flashnode_sess_dev_type",
>  	.groups = iscsi_flashnode_sess_attr_groups,
>  	.release = iscsi_flashnode_sess_release,
> @@ -1195,13 +1195,13 @@ static void
> iscsi_flashnode_conn_release(struct device *dev)
>  	kfree(fnode_conn);
>  }
> 
> -struct device_type iscsi_flashnode_conn_dev_type = {
> +static struct device_type iscsi_flashnode_conn_dev_type = {
>  	.name = "iscsi_flashnode_conn_dev_type",
>  	.groups = iscsi_flashnode_conn_attr_groups,
>  	.release = iscsi_flashnode_conn_release,
>  };
> 
> -struct bus_type iscsi_flashnode_bus;
> +static struct bus_type iscsi_flashnode_bus;
> 
>  int iscsi_flashnode_bus_match(struct device *dev,
>  				     struct device_driver *drv)
> @@ -1212,7 +1212,7 @@ int iscsi_flashnode_bus_match(struct device *dev,
>  }
>  EXPORT_SYMBOL_GPL(iscsi_flashnode_bus_match);
> 
> -struct bus_type iscsi_flashnode_bus = {
> +static struct bus_type iscsi_flashnode_bus = {
>  	.name = "iscsi_flashnode",
>  	.match = &iscsi_flashnode_bus_match,
>  };

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
