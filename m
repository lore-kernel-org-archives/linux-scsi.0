From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] Remove the unnecessary semicolons
Date: Thu, 15 Sep 2016 12:11:50 +0200
Message-ID: <66b617df-f7a3-e2d0-07da-8d9b03771570@redhat.com>
References: <1471572189-21257-1-git-send-email-zhoujie2011@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36718 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753312AbcIOKLy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2016 06:11:54 -0400
In-Reply-To: <1471572189-21257-1-git-send-email-zhoujie2011@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhou Jie <zhoujie2011@cn.fujitsu.com>, linux-scsi@vger.kernel.org
Cc: mst@redhat.com, rusty@rustcorp.com.au, stefanha@linux.vnet.ibm.com, Chao Fan <fanc.fnst@cn.fujitsu.com>, kernel-janitors@vger.kernel.org



On 19/08/2016 04:03, Zhou Jie wrote:
> At the end of funcions, semicolons are unnecessary. So drop them.
> 
> Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
> ---
>  drivers/scsi/virtio_scsi.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 7dbbb29..9632a0c 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -241,7 +241,7 @@ static void virtscsi_req_done(struct virtqueue *vq)
>  	struct virtio_scsi_vq *req_vq = &vscsi->req_vqs[index];
>  
>  	virtscsi_vq_done(vscsi, req_vq, virtscsi_complete_cmd);
> -};
> +}
>  
>  static void virtscsi_poll_requests(struct virtio_scsi *vscsi)
>  {
> @@ -267,7 +267,7 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
>  	struct virtio_scsi *vscsi = shost_priv(sh);
>  
>  	virtscsi_vq_done(vscsi, &vscsi->ctrl_vq, virtscsi_complete_free);
> -};
> +}
>  
>  static void virtscsi_handle_event(struct work_struct *work);
>  
> @@ -413,7 +413,7 @@ static void virtscsi_event_done(struct virtqueue *vq)
>  	struct virtio_scsi *vscsi = shost_priv(sh);
>  
>  	virtscsi_vq_done(vscsi, &vscsi->event_vq, virtscsi_complete_event);
> -};
> +}
>  
>  /**
>   * virtscsi_add_cmd - add a virtio_scsi_cmd to a virtqueue
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
