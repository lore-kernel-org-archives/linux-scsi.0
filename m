From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: TRIM/UNMAP/DISCARD via ATA Passthrough
Date: Sat, 17 Sep 2016 03:24:12 +0200
Message-ID: <CAHmME9rJVUWwwzV6GCs_jESgBPe7XPOsehVZ0kgV0a71R9jjYg@mail.gmail.com>
References: <CAHmME9q4TV4EVAK-4X8Fx9x_YYT3fh4zbtQgjnFR4ut7dTUUfA@mail.gmail.com>
 <yq1d1k6l43x.fsf@sermon.lab.mkp.net> <CAHmME9pX1sSdFLfsgBqunh=5ttmPg5-vAzvTEfD1Xt4NBk6JzA@mail.gmail.com>
 <yq1twdhb0zr.fsf@sermon.lab.mkp.net> <CAHmME9qq5vSC+hZckCystU6cdRPihO492U2B2-pozbwg=3_5nw@mail.gmail.com>
 <5af202ea-a632-28c2-515f-c361e27de5da@suse.de> <c2c154db-67fe-dcaa-a46a-48a53e15d1cf@gmail.com>
 <1474042904.2353.52.camel@HansenPartnership.com> <add395b3-80df-0402-d8b7-d2fb79d9aebf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:58156 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753252AbcIQBYX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Sep 2016 21:24:23 -0400
In-Reply-To: <add395b3-80df-0402-d8b7-d2fb79d9aebf@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Fri, Sep 16, 2016 at 7:06 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> 1. UAS (not some other SCSI transport) without UNMAP support.
> 2. Supports ATA_12 or ATA_16 pass through.
> 3. ATA DEVICE IDENTIFY via SAT indicates that the device supports
> DISCARD/TRIM.
> Then we'd be matching behavior on Windows, and should probably be relativ=
ely
> safe.

This very clearly seems like a sensible plan. It's nice to learn that
someone with a USB sniffer (and not just a d=C3=A9sassembler :P) confirms
this is what Windows is doing. I see no reason for Linux not to do the
same. Are there any remaining objections to this plan?
