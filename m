From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1][] Test opcode, not definition in type_check(), drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
Date: Tue, 29 Jan 2008 10:43:48 +0100
Message-ID: <479EF554.3000601@suse.de>
References: <479DD422.60006@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:51297 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbYA2Jnt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jan 2008 04:43:49 -0500
In-Reply-To: <479DD422.60006@tiscali.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <12o3l@tiscali.nl>
Cc: linux-scsi@vger.kernel.org

Roel Kluin wrote:
> drivers/scsi/aic7xxx_old/sequencer.h:130:#define AIC_OP_JZ 0xf
> --
> Test opcode, not definition
>=20
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: Hannes Reinecke <hare@suse.de>

> ---
> diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y b/drivers/scsi=
/aic7xxx/aicasm/aicasm_gram.y
> index 6066998..702e2db 100644
> --- a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
> +++ b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
> @@ -1837,7 +1837,7 @@ type_check(symbol_t *symbol, expression_t *expr=
ession, int opcode)
>  	int and_op;
> =20
>  	and_op =3D FALSE;
> -	if (opcode =3D=3D AIC_OP_AND || opcode =3D=3D AIC_OP_JNZ || AIC_OP_=
JZ)
> +	if (opcode =3D=3D AIC_OP_AND || opcode =3D=3D AIC_OP_JNZ || opcode =
=3D=3D AIC_OP_JZ)
>  		and_op =3D TRUE;
> =20
>  	/*

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
