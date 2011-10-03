From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: HighPoint RocketRaid 620 vs. RocketRaid 640 -- supported?
Date: Mon, 3 Oct 2011 16:16:52 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1110031615490.20248@p34.internal.lan>
References: <alpine.DEB.2.02.1109191754531.7938@p34.internal.lan> <alpine.DEB.2.02.1109210726250.31360@p34.internal.lan> <20111003201315.GD12984@reaktio.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655616-1354032898-1317673012=:20248"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lucidpixels.com ([72.73.18.11]:47935 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab1JCUQw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Oct 2011 16:16:52 -0400
In-Reply-To: <20111003201315.GD12984@reaktio.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-15?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655616-1354032898-1317673012=:20248
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 3 Oct 2011, Pasi K=E4rkk=E4inen wrote:

> On Wed, Sep 21, 2011 at 07:28:26AM -0400, Justin Piszcz wrote:
>> Hi,
>>
>> Incase anyone is wondering the same thing, I contacted Highpoint and the=
y
>> said (confirmed) the 620 support (which I am using now) is built-in to
>> the kernel and the 640 is not, so unless you like compiling kernel
>> modules/out of tree drivers for a _boot_ volume and want a regular SATA
>> 6.0gbps controller that supports TRIM, I'd go for the 620 even though it
>> maxes out around 390-420MiB/s read where a real SAS controller supports
>> 490-500MiB/s for an Intel 510 SSD, but remember, SAS controllers (at
>> least the one I tested with does not support TRIM and there is no Intel
>> SSD optimizer for Linux.
>>
>
> Hmm.. does SAS "SCSI UNMAP" automatically get translated to
> ATA TRIM if you hook up SATA disk to SAS HBA ?
When attached to a SAS HBA, it simply says:

Jul 14 16:12:03 p34 kernel: [   22.258855] EXT4-fs warning (device sda2): r=
elease_blocks_on_commit:2679: discard not supported, disabling

>
> Is the ATA<->SCSI translation being done by the HBA firmware,
> or is it handled in the driver?
I'm not sure, it would appear the driver handles it, when its on the Sata 6=
gbps
card (not SAS), it works fine:
Sep 20 13:53:34 p34 kernel: [    6.786898] EXT4-fs (sdb2): re-mounted. Opts=
: discard

>
> -- Pasi (who is too lazy to grep in the driver right now ;)

Justin.

--655616-1354032898-1317673012=:20248--
