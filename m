From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] debloat aic7xxx and aic79xx drivers
Date: Mon, 07 Apr 2008 12:31:25 +0200
Message-ID: <47F9F7FD.908@suse.de>
References: <200803230440.40685.vda.linux@googlemail.com> <200803230441.22926.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:49341 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245AbYDGKb1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Apr 2008 06:31:27 -0400
In-Reply-To: <200803230441.22926.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Denys,

Denys Vlasenko wrote:
> Deinlines and moves big functions from .h to .c files.
> Adds prototypes for ahc_lookup_scb and ahd_lookup_scb to .h files.
>=20
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> --
> vda
Patch looks good to me.

Signed-off-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
