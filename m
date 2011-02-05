From: "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over 10GbE?
Date: Sat, 5 Feb 2011 22:06:21 +0000
Message-ID: <20110205220621.GB17347@gallifrey>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan> <20110205214550.3cb0f0d1@galadriel2.home> <alpine.DEB.2.00.1102051553591.8518@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.treblig.org ([80.68.94.177]:41850 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab1BEWGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Feb 2011 17:06:25 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102051553591.8518@p34.internal.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>

* Justin Piszcz (jpiszcz@lucidpixels.com) wrote:
>
>
> On Sat, 5 Feb 2011, Emmanuel Florac wrote:
>
>> Le Sat, 5 Feb 2011 14:35:52 -0500 (EST) vous =E9criviez:
>>
>
> To respond to everyone:
>
>> Did you try launching 4 simultaneous cp operations over nfs to get t=
o =20
>> 1.2 GB/s?
>>  I've witnessed single stream copy performance with Samba being less=
 than
>> maximum due to Samba limitations.  Running multiple copy ops in para=
llel then
>> usually saturates the pipe.
>
>
> I tried 4 simultaenous cp's and there was little change, 250-320MiB/s=
=2E

So I think you've said network benchmarks are OK, disc benchmarks are O=
K, but=20
a copy over the network is slow.

What happens if you run a disc benchmark at the same time as a network =
benchmark;
even though the two aren't related? Can you keep the disc busy writing =
even when
the network is being pushed?

Dave
--=20
 -----Open up your eyes, open up your mind, open up your code -------  =
=20
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \=20
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
