From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from
	emulated SCSI hosts
Date: 22 Apr 2003 15:31:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051021911.14880.25.camel@dhcp22.swansea.linux.org.uk>
References: <UTC200304220109.h3M19NX09680.aeb@smtp.cwi.nl>
	 <20030421181755.A19118@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:22494
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S263233AbTDVPSV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 11:18:21 -0400
In-Reply-To: <20030421181755.A19118@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Andries.Brouwer@cwi.nl, James Bottomley <James.Bottomley@SteelEye.com>, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, Linus Torvalds <torvalds@transmeta.com>, usb-storage@one-eyed-alien.net

On Maw, 2003-04-22 at 02:17, Matthew Dharm wrote:
> Your patches went a long way to improving things.  But, then people added
> EVPD and further changed MODE_SENSE and other things.   It's pretty clear
> to me that trying to change the SCSI core to not use these commands isn't
> going to happen -- so I want a way to filter them.  I originally wanted a
> centralized filter (i.e. usb-storage could indicate to the mid-layer not to
> send the 'unwelcome' commands), but that got shot down in favor of a
> centralized filter-framework which could be applied by any LLDD that wanted
> to.

You already can do this. You just need to write yourself a library
routine which converts/blocks according to the filter rules (ie
read6->read10, returns errors to fancy stuff etc).


