From: Matei Oprea <eu@opreamatei.ro>
Subject: Re: [PATCH] scsi: lpfc: lpfc_init: use kcalloc for allocating memory
Date: Mon, 7 Apr 2014 15:37:41 +0300
Message-ID: <CABeAxadUHD9wdyJQs0V4bC+pbXSutssBaY7wXSs1bVVqbD_DQA@mail.gmail.com>
References: <1395175900-9659-1-git-send-email-eu@opreamatei.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:40327 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbaDGMhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2014 08:37:42 -0400
Received: by mail-oa0-f43.google.com with SMTP id eb12so6565890oac.30
        for <linux-scsi@vger.kernel.org>; Mon, 07 Apr 2014 05:37:42 -0700 (PDT)
In-Reply-To: <1395175900-9659-1-git-send-email-eu@opreamatei.ro>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: james.smart@emulex.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Matei Oprea <eu@opreamatei.ro>, ROSEdu Kernel Community <firefly@lists.rosedu.org>

Any comments on this ?
=E1=90=A7

On Tue, Mar 18, 2014 at 10:51 PM, Matei Oprea <eu@opreamatei.ro> wrote:
> It's easier to use kcalloc for allocating arrays. While at it
> also remove useless casting value.
>
> Signed-off-by: Matei Oprea <eu@opreamatei.ro>
> Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
> ---
>  drivers/scsi/lpfc/lpfc_init.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_i=
nit.c
> index 68c94cc..0a51ca5 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4731,9 +4731,9 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba =
*phba)
>         }
>
>         if (!phba->sli.ring)
> -               phba->sli.ring =3D (struct lpfc_sli_ring *)
> -                       kzalloc(LPFC_SLI3_MAX_RING *
> +               phba->sli.ring =3D kcalloc(LPFC_SLI3_MAX_RING,
>                         sizeof(struct lpfc_sli_ring), GFP_KERNEL);
> +
>         if (!phba->sli.ring)
>                 return -ENOMEM;
>
> --
> 1.7.9.5
>



--=20
Oprea Matei
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
