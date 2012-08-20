From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] [SCSI] virtio-scsi: Initialize scatterlist structure.
Date: Mon, 20 Aug 2012 16:05:45 +0200
Message-ID: <50324439.1000307@redhat.com>
References: <1345471490-17289-1-git-send-email-rjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1345471490-17289-1-git-send-email-rjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 20/08/2012 16:04, Richard W.M. Jones ha scritto:
> From: "Richard W.M. Jones" <rjones@redhat.com>
> 
> The sg struct is used without being initialized.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=847548
> 
> Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index c7030fb..8a66f83 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -219,7 +219,7 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
>  	struct scatterlist sg;
>  	unsigned long flags;
>  
> -	sg_set_buf(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
> +	sg_init_one(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
>  
>  	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
>  
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo
