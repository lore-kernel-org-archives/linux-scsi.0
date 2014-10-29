From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 11/36] ncr5380: Remove NCR5380_STATS
Date: Wed, 29 Oct 2014 17:11:01 +0100
Message-ID: <54511195.5080003@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052609.795427901@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934055AbaJ2QLe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2014 12:11:34 -0400
In-Reply-To: <20141027052609.795427901@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> The NCR5380_STATS option is only enabled by g_NCR5380 yet it adds
> clutter to all three core drivers. The atari_NCR5380.c and sun3_NCR53=
80.c
> core drivers have a slightly different implementation of the
> NCR5380_STATS option.
>
> Out of all ten NCR5380 drivers, only one of them (g_NCR5380) actually
> has the code to report on the collected stats. Aside from being unrea=
dable,
> that code seems to be broken because there's no initialization of tim=
ebase.
> sun3_NCR5380.c and atari_NCR5380.c have the timebase initialization b=
ut
> lack the code to report the stats.
>
> Remove all of this code to improve readability and reduce divergence
> between the three core drivers.
>
> This patch and the next one completely eliminate the PRINTP and ANDP
> pre-processor abuse.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
