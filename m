From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting root
Date: Thu, 19 Jun 2008 14:49:55 -0600
Message-ID: <20080619204954.GQ4392__45685.4352298707$1213908684$gmane$org@parisc-linux.org>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <48118DDD.8010507@s5r6.in-berlin.de> <Pine.LNX.4.64.0804251110400.758@sbz-30.cs.Helsinki.FI> <20080425091122.GA14990@parisc-linux.org> <20080619182310.GA30833@parisc-linux.org> <485AA7EA.6080105@s5r6.in-berlin.de> <20080619185419.GN4392@parisc-linux.org> <20080619195240.GX19934@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37633 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbYFSUuL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2008 16:50:11 -0400
Content-Disposition: inline
In-Reply-To: <20080619195240.GX19934@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, Pekka J Enberg <penberg@cs.helsinki.fi>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, dsd@gentoo.org, linux-usb@v

On Thu, Jun 19, 2008 at 12:52:40PM -0700, Matthew Dharm wrote:
> First, there are usb-storage devices which are USB<->SCSI bridges and
> therefore support multiple target devices.

This is true.

> Second, you would still need multiple hosts when you have more than 15
> target USB devices, anyway.

This isn't true.  Look at topologies like fibre channel which can have
thousands of targets on a single host.

I would suggest that you want one 'channel' per usb endpoint.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
