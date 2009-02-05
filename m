From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH] iscsi tcp: bidi capable
Date: Thu, 05 Feb 2009 16:45:32 -0600
Message-ID: <498B6C0C.1070008@cs.wisc.edu>
References: <4975D96A.6020407@panasas.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <4975D96A.6020407-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Pete Wyckoff <pw-VNBDo6LsbKA@public.gmane.org>, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open-osd mailing-list <osd-dev-yNzVSZO3znNg9hUCZPvPmw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


Boaz Harrosh wrote:
> From: Pete Wyckoff <pw-VNBDo6LsbKA@public.gmane.org>
> 
> Mark iscsi_tcp as being capable of bidirectional transfers.  The
> bsg interface checks this bit before attempting any bidirectional
> commands.
> 
> Signed-off-by: Pete Wyckoff <pw-VNBDo6LsbKA@public.gmane.org>
> Signed-off-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/scsi/iscsi_tcp.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index af092a8..9e2d4fb 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -806,6 +806,12 @@ static void iscsi_sw_tcp_session_destroy(struct iscsi_cls_session *cls_session)
>  	iscsi_host_free(shost);
>  }
>  
> +static int iscsi_tcp_slave_alloc(struct scsi_device *sdev)
> +{

I merged this for 2.6.30 with a small change where this is renamed 
iscsi_sw_tcp_slave_alloc to fit the naming of functions in that file.

Thanks.
