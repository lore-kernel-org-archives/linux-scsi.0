From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/71] ncr5380: Move NCR53C400-specific code
Date: Thu, 19 Nov 2015 14:31:52 +0100
Message-ID: <564DCF48.1000103@suse.de>
References: <20151118083455.331768508@telegraphics.com.au> <20151118083457.371688319@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932745AbbKSNbz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2015 08:31:55 -0500
In-Reply-To: <20151118083457.371688319@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 11/18/2015 09:35 AM, Finn Thain wrote:
> Move board-specific code like this,
> 	NCR5380_write(C400_CONTROL_STATUS_REG, CSR_BASE);
> from the core driver to the board driver. Eliminate the NCR53C400 mac=
ro
> from the core driver. Removal of all macros like this one will be
> necessary in order to have one core driver that can support all kinds=
 of
> boards.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.c   |   18 ------------------
>  drivers/scsi/g_NCR5380.c |   23 ++++++++++++++++++-----
>  drivers/scsi/g_NCR5380.h |    6 ++----
>  3 files changed, 20 insertions(+), 27 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
