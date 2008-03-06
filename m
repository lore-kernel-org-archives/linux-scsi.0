From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [2.6 patch] SCSI_AIC94XX must depend on SCSI
Date: Thu, 6 Mar 2008 12:35:58 -0800
Message-ID: <20080306203558.GA7430@tree.beaverton.ibm.com>
References: <200803062009.20309.toralf.foerster@gmx.de> <20080306202246.GB5259@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41518 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbYCFUgA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Mar 2008 15:36:00 -0500
Content-Disposition: inline
In-Reply-To: <20080306202246.GB5259@cs181133002.pp.htv.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 10:22:46PM +0200, Adrian Bunk wrote:
> This patch fixes the following build error reported by Toralf F=F6rst=
er:
>=20
> <--  snip  -->
>=20
> ...
>   MODPOST 243 modules
> ERROR: "sas_bios_param" [drivers/scsi/mvsas.ko] undefined!

<snip>

> --- a/drivers/scsi/aic94xx/Kconfig
> +++ b/drivers/scsi/aic94xx/Kconfig

Maybe I'm missing something here, but how does patching aic94xx Kconfig
fix an mvsas build problem?

--D
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
