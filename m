From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH][RESEND] [SCSI] aic7xxx: remove duplicate define
Date: Mon, 09 Dec 2013 11:01:31 +0100
Message-ID: <52A594FB.6020700@suse.de>
References: <1382524483-3167-1-git-send-email-michael.opdenacker@free-electrons.com> <1386582956-4942-1-git-send-email-michael.opdenacker@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1386582956-4942-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/09/2013 10:55 AM, Michael Opdenacker wrote:
> Remove duplicate define
> in drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
>=20
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.=
com>
> ---
>  drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h b/drivers=
/scsi/aic7xxx/aicasm/aicasm_insformat.h
> index 9df9e2ce3538..8373447bd7d3 100644
> --- a/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
> +++ b/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
> @@ -209,7 +209,6 @@ struct instruction {
>  #define AIC_OP_JC16	0x9105
>  #define AIC_OP_JNC16	0x9205
>  #define AIC_OP_CALL16	0x9305
> -#define AIC_OP_CALL16	0x9305
> =20
>  /* Page extension is low three bits of second opcode byte. */
>  #define AIC_OP_JMPF	0xA005
>=20
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
