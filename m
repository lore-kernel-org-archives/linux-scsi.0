From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [2.6 patch] scsi/qla4xxx/ql4_isr.c: remove dead code
Date: Thu, 21 Feb 2008 12:51:23 +0100
Message-ID: <200802211251.34437.eike-kernel@sf-tec.de>
References: <0BB3E5E7462EEA4295BC02D49691DC0701277989@AVEXCH1.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2537298.1IBjjA3VHb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:55874 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbYBUL6U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Feb 2008 06:58:20 -0500
In-Reply-To: <0BB3E5E7462EEA4295BC02D49691DC0701277989@AVEXCH1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Somayajulu <david.somayajulu@qlogic.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

--nextPart2537298.1IBjjA3VHb
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> The correct patch needs to be
>
> Signed-off-by: David C Somayajulu <david.somayajulu@qlogic.com>
>
> ---
>
> diff --git a/drivers/scsi/qla4xxx/ql4_isr.c
> b/drivers/scsi/qla4xxx/ql4_isr.c
> index 0f029d0..fc84db4 100644
> --- a/drivers/scsi/qla4xxx/ql4_isr.c
> +++ b/drivers/scsi/qla4xxx/ql4_isr.c
> @@ -100,8 +100,7 @@ static void qla4xxx_status_entry(struct
>
>  		if (sts_entry->iscsiFlags &ISCSI_FLAG_RESIDUAL_UNDER) {
>  			scsi_set_resid(cmd, residual);
> -			if (!scsi_status && ((scsi_bufflen(cmd) -
> residual) <
> -				cmd->underflow)) {
> +			if ((scsi_bufflen(cmd) - residual) <
> cmd->underflow) {

The patch is line-wrapped and can' be applied.

Greetings,

Eike

--nextPart2537298.1IBjjA3VHb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHvWXGXKSJPmm5/E4RArLGAKCmtRwDDDnSOeBTtYVIyT4x+/I3rgCgob5p
p2A/YBvALCGRhySCQ67Css0=
=gRJ+
-----END PGP SIGNATURE-----

--nextPart2537298.1IBjjA3VHb--
