From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] scsi: make scsi_devinfo infrastructure optional
Date: Thu, 10 Feb 2011 10:18:47 +0100
Message-ID: <AANLkTimE1H=hos+YMW3Ge9vkETC9f1k1Dt6AMi5iLHGW@mail.gmail.com>
References: <201102091515.16202.bzolnier@gmail.com>
	<1297274408.3016.29.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1297274408.3016.29.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 9, 2011 at 7:00 PM, James Bottomley <James.Bottomley@suse.d=
e> wrote:
> On Wed, 2011-02-09 at 15:15 +0100, Bartlomiej Zolnierkiewicz wrote:
>> Add SCSI_QUIRKS config option (default y and dependent on EMBEDDED
>> config option) to allow disabling of scsi_devinfo infrastructure.
>>
>> The output code size savings are ~14k for CONFIG_SCSI_QUIRKS=3Dn
>> (as measured on x86-32):
>
> I don't understand the point of this patch ... without the quirks SCS=
I
> will do the wrong thing on a whole bunch of stuff. =A0The savings loo=
k to
> be tiny ... since the SCSI module is habitually a lot larger than you=
r
> figures suggest.

The patch was originally done for embedded ATA-only setups.

Thanks,
Bartlomiej
