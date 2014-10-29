From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 12/36] ncr5380: Cleanup host info() methods
Date: Wed, 29 Oct 2014 17:17:31 +0100
Message-ID: <5451131B.9070208@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052610.035420500@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141027052610.035420500@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> If the host->info() method is not set, then host->name is used by def=
ault.
> For atari_scsi, that is exactly the same text. So remove the redundan=
t
> info() method. Keep sun3_scsi.c in line with atari_scsi.
>
> Some NCR5380 drivers return an empty string from the info() method
> (arm/cumana_1.c arm/oak.c mac_scsi.c) while other drivers use the def=
ault
> (dmx3191d dtc.c g_NCR5380.c pas16.c t128.c).
>
> Implement a common info() method to replace a lot of duplicated code =
which
> the various drivers use to announce the same information.
>
> This replaces most of the (deprecated) show_info() output and all of =
the
> NCR5380_print_info() output. This also eliminates a bunch of code in
> g_NCR5380 which just duplicates functionality in the core driver.
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
