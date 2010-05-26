From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: megaraid sparse warnings
Date: Wed, 26 May 2010 15:00:51 -0700
Message-ID: <20100526150051.1006e724.rdunlap@xenotime.net>
References: <4B7788B8.8090005@xenotime.net>
	<20100526142802.1c06d5c1.rdunlap@xenotime.net>
	<20100526213947.GW31073@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.115.56]:47044 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753119Ab0EZWAy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2010 18:00:54 -0400
Received: from chimera.site ([71.245.98.113]) by xenotime.net for <linux-scsi@vger.kernel.org>; Wed, 26 May 2010 15:00:52 -0700
In-Reply-To: <20100526213947.GW31073@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, scsi <linux-scsi@vger.kernel.org>

On Wed, 26 May 2010 22:39:47 +0100 Al Viro wrote:

> On Wed, May 26, 2010 at 02:28:02PM -0700, Randy Dunlap wrote:
> > ping??
> > > 		sprintf (adapter->fw_version, "%c%d%d.%d%d",
> > > 			 adapter->product_info.fw_version[2],
> > > 			 adapter->product_info.fw_version[1] >> 8,
> > > 			 adapter->product_info.fw_version[1] & 0x0f,
> > > 			 adapter->product_info.fw_version[0] >> 8,
> > > 			 adapter->product_info.fw_version[0] & 0x0f);
> > > 		sprintf (adapter->bios_version, "%c%d%d.%d%d",
> > > 			 adapter->product_info.bios_version[2],
> > > 			 adapter->product_info.bios_version[1] >> 8,
> > > 			 adapter->product_info.bios_version[1] & 0x0f,
> > > 			 adapter->product_info.bios_version[0] >> 8,
> > > 			 adapter->product_info.bios_version[0] & 0x0f);
> > > 	} else {
> 
> > > Are the fw_version and bios_version fields more than 8 bits each for HP subsys VID
> > > products?  Do HP VID products need a different struct so that they print this info
> > > correctly?
> 
> Since both are claimed to be strings, I really suspect that this >> 8 is
> misspelled >> 4 and they have a character followed by pair of two-digit
> packed decimals in there...

Duh.  Makes perfect sense.

Thanks, Al.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
