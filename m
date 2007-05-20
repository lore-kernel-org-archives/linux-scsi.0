From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [Scst-devel] Problems with SCST and QLA 2432 FC Cards
Date: Sat, 19 May 2007 20:55:39 -0700
Message-ID: <20070520035539.GB7930@n6502ukq19261.qlogic.org>
References: <2d19f51c0e0a50bbea21c1a83f21965b@cgw.capvert.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:26218 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbXETDzn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 May 2007 23:55:43 -0400
Content-Disposition: inline
In-Reply-To: <2d19f51c0e0a50bbea21c1a83f21965b@cgw.capvert.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johan Kragsterman <johan.kragsterman@capvert.se>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, sandip shete <sandipshete@gmail.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Sat, 19 May 2007, Johan Kragsterman wrote:

> Andrew Vasquez <andrew.vasquez@qlogic.com> Skrev: 
> >
> >QLogic doesn't formally release target-mode drivers for their ISP
> >chips.  Matthew J. has done a great job at providing a community
> >available souce-base from which to draw ideas and code from.
> >
> >Regards,
> >Andrew Vasquez
> >
> >
> So, Andrew, do you officially represent Qlogic? If so, your point of view
> here is interesting, since you seem to consider that: "Matthew J. has done a
> great job at providing a community available souce-base from which to draw
> ideas and code from".

Matthew's driver works on a variety of *nix platforms which QLogic
does not provide drivers for -- *BSD varients, etc.   He also has a
fine target-mode driver which others can reference.

>  In what way is Qlogic interested in helping the community with providing
> open firmware,

We've worked with various members of the open-source community to
address some of licensing issues.  At this stage we provide
firmware-blobs for all our ISPs under the (3 clause) BSD license:

	ftp://ftp.qlogic.com/outgoing/linux/firmware/

Firmware specifications are still tightly circulated.

> drivers and tools?

If there's some specific OS's and 'tools' you'd like to see more work
on from QLogic, then I can forward your request up-the-chain.

--
Andrew Vasquez
