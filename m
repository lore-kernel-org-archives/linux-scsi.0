From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/5] scsi_transport_iscsi: Unexport
 iscsi_is_flashnode_conn_dev()
Date: Thu, 31 Mar 2016 10:02:12 +0200
Message-ID: <921c805f91ba210838d88c266c1e6fbd@suse.de>
References: <56FC1A3B.4040704@sandisk.com> <56FC1AA3.5040600@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbcCaICN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 04:02:13 -0400
In-Reply-To: <56FC1AA3.5040600@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2016-03-30 20:27, Bart Van Assche wrote:
> The output of "git grep -nHw iscsi_is_flashnode_conn_dev" shows
> that this function is only called from inside source file
> drivers/scsi/scsi_transport_iscsi.c. Hence unexport this function.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c
> b/drivers/scsi/scsi_transport_iscsi.c
> index 446781d..dff7413 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1324,11 +1324,10 @@ EXPORT_SYMBOL_GPL(iscsi_create_flashnode_conn);
>   *  1 on success
>   *  0 on failure
>   */
> -int iscsi_is_flashnode_conn_dev(struct device *dev, void *data)
> +static int iscsi_is_flashnode_conn_dev(struct device *dev, void *data)
>  {
>  	return dev->bus == &iscsi_flashnode_bus;
>  }
> -EXPORT_SYMBOL_GPL(iscsi_is_flashnode_conn_dev);
> 
>  static int iscsi_destroy_flashnode_conn(struct iscsi_bus_flash_conn
> *fnode_conn)
>  {

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
