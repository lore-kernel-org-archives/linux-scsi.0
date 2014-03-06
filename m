From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] virtio-scsi: Change sense buffer size to 252
Date: Thu, 06 Mar 2014 11:09:38 +0100
Message-ID: <53184962.3080100@redhat.com>
References: <1394095660-15075-1-git-send-email-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1394095660-15075-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 06/03/2014 09:47, Fam Zheng ha scritto:
> According to SPC-4, section 4.5.2.1, 252 is the limit of sense data. So
> increase the value.
>
> Signed-off-by: Fam Zheng <famz@redhat.com>
> ---
>  include/linux/virtio_scsi.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
> index 4195b97..a437f7f 100644
> --- a/include/linux/virtio_scsi.h
> +++ b/include/linux/virtio_scsi.h
> @@ -28,7 +28,7 @@
>  #define _LINUX_VIRTIO_SCSI_H
>
>  #define VIRTIO_SCSI_CDB_SIZE   32
> -#define VIRTIO_SCSI_SENSE_SIZE 96
> +#define VIRTIO_SCSI_SENSE_SIZE 252
>
>  /* SCSI command request, followed by data-out */
>  struct virtio_scsi_cmd_req {
>

Hi Fam, how did you test this?

Paolo
