From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [TRIVIAL] warning cleanup for drivers_scsi_qla1280.c
Date: 07 Aug 2002 14:24:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1028726672.18130.293.camel@irongate.swansea.linux.org.uk>
References: <20020807043057.395C74BD6@lists.samba.org>
	<1028720225.18156.246.camel@irongate.swansea.linux.org.uk>
	<3D510084.3040708@cox.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D510084.3040708@cox.net>
List-Id: linux-scsi@vger.kernel.org
To: Steve Ralston <sjralston1@cox.net>
Cc: linux-scsi@vger.kernel.org

On Wed, 2002-08-07 at 12:12, Steve Ralston wrote:
> On 08/07/2002 06:37 AM, Alan Cox wrote:
> 
> >General policy - rip out version ifdefs unless the driver has a
> >maintainer who actively objects ?
> >
> 
> So just curious, are you saying that you'd rather have driver maintainers
> maintain a separate set of driver source for each explicit kernel (with no
> version-specific #ifdef's) vs. the way we did it above?

If someone is maintaining them all then there are cases it makes sense
to leave the ifdefs in. Thats why I said about maintainers who actively
object. I suspect Deanna would also want the MPT fusion ifdefs left in
for example

