From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 23/77] ncr5380: Always retry arbitration and selection
Date: Tue, 22 Dec 2015 08:14:59 +0100
Message-ID: <5678F873.2020005@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011744.275507291@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbbLVHPB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Dec 2015 02:15:01 -0500
In-Reply-To: <20151222011744.275507291@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 12/22/2015 02:18 AM, Finn Thain wrote:
> If NCR5380_select() returns -1, it means arbitration was lost or sele=
ction
> failed and should be retried. If the main loop simply terminates when=
 there
> are still commands on the issue queue, they will remain queued until =
they
> expire.
>
> Fix this by clearing the 'done' flag after selection failure or lost
> arbitration.
>
> The "else break" clause in NCR5380_main() that gets removed here appe=
ars
> to be a vestige of a long-gone loop that iterated over host instances=
=2E
> See commit 491447e1fcff ("[PATCH] next NCR5380 updates") in
> history/history.git.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
