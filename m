From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-usb-devel] Re: [usb-storage] Re: PATCH: exclude certain
	commands from emulated SCSI hosts
Date: 22 Apr 2003 16:05:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051023931.15160.36.camel@dhcp22.swansea.linux.org.uk>
References: <UTC200304220109.h3M19NX09680.aeb@smtp.cwi.nl>
	 <20030421181755.A19118@one-eyed-alien.net>
	 <1051021911.14880.25.camel@dhcp22.swansea.linux.org.uk>
	 <20030422083621.B28101@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:30174
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S263214AbTDVPvm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 11:51:42 -0400
In-Reply-To: <20030422083621.B28101@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Andries.Brouwer@cwi.nl, James Bottomley <James.Bottomley@SteelEye.com>, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, Linus Torvalds <torvalds@transmeta.com>, usb-storage@one-eyed-alien.net

On Maw, 2003-04-22 at 16:36, Matthew Dharm wrote:
> I thought that the entire point was to have all this in a centralized place
> for use by multiple LLDDs (or anyone else for that matter).  Which is the
> entire point of this discussion.

Centralise it, but as a library function. Its up to host controllers to
call the filter functions and indicate what they want fixing up.
Centralised is good but nailing it directly into the midlayer reduces
flexibility a lot

