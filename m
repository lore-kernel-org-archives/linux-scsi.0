From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: PATCH; make sr.c respect use_10_for_ms
Date: Sat, 21 Jun 2003 17:07:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0306211706390.1980-100000@home.transmeta.com>
References: <20030621165920.F2811@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from neon-gw-l3.transmeta.com ([63.209.4.196]:23056 "EHLO
	neon-gw.transmeta.com") by vger.kernel.org with ESMTP
	id S264674AbTFUXyE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jun 2003 19:54:04 -0400
In-Reply-To: <20030621165920.F2811@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>


On Sat, 21 Jun 2003, Matthew Dharm wrote:
>
> This patch makes sr.c respect the use_10_for_ms flag.

Ouch.

Is there some SCSI person out there that would be willing to make sr.c 
look a bit more like sd.c in this respect? This is a bit hacky, I think, 
but I guess the sr.c layout forces that..

		Linus

