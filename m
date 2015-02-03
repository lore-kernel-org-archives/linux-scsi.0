From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH-v3 8/9] vhost/scsi: Drop left-over scsi_tcq.h include
Date: Tue, 3 Feb 2015 11:38:49 +0200
Message-ID: <20150203093849.GM2830@redhat.com>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
 <1422945003-24538-9-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1422945003-24538-9-git-send-email-nab@daterainc.com>
Sender: kvm-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 03, 2015 at 06:30:02AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> With the recent removal of MSG_*_TAG defines in commit 68d81f40,
> vhost-scsi is now using TCM_*_TAG and doesn't depend upon host
> side scsi_tcq.h definitions anymore.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/vhost/scsi.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 9af93d0..2b4b002 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -38,7 +38,6 @@
>  #include <linux/miscdevice.h>
>  #include <asm/unaligned.h>
>  #include <scsi/scsi.h>
> -#include <scsi/scsi_tcq.h>
>  #include <target/target_core_base.h>
>  #include <target/target_core_fabric.h>
>  #include <target/target_core_fabric_configfs.h>
> -- 
> 1.9.1
