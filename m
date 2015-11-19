From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 15/71] ncr5380: Always escalate bad target time-out in
 NCR5380_select()
Date: Thu, 19 Nov 2015 15:15:52 +0100
Message-ID: <564DD998.3030508@suse.de>
References: <20151118083455.331768508@telegraphics.com.au> <20151118083459.282154727@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934200AbbKSOPy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2015 09:15:54 -0500
In-Reply-To: <20151118083459.282154727@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 11/18/2015 09:35 AM, Finn Thain wrote:
> Remove the restart_select and targets_present variables introduced in
> Linux v1.1.38. The former was used only for a questionable debug prin=
tk
> and the latter "so we can call a select failure a retryable condition=
".
> Well, retrying select failure in general is a different problem to a
> target that doesn't assert BSY. We need to handle these two cases
> differently; the latter case can be left to the SCSI ML.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.c       |   13 -------------
>  drivers/scsi/NCR5380.h       |    6 ------
>  drivers/scsi/atari_NCR5380.c |   13 -------------
>  3 files changed, 32 deletions(-)
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
