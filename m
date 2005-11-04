From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating
	SMART/ATA-Security in usb-storage driver
Date: Fri, 04 Nov 2005 12:33:50 -0600
Message-ID: <1131129230.3532.40.camel@mulgrave>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3A@WDSCEXBECL03.sc.wdc.com>
	 <20051102234532.GC26148@one-eyed-alien.net>
	 <1131077287.3117.22.camel@mulgrave>
	 <20051104172844.GA12384@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:44729 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750806AbVKDSd4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Nov 2005 13:33:56 -0500
In-Reply-To: <20051104172844.GA12384@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Timothy Thelin <Timothy.Thelin@wdc.com>, t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>

On Fri, 2005-11-04 at 09:28 -0800, Matthew Dharm wrote:
> > I've no distinct recollection of someone removing this, but if I
> > remember correctly what it used to do, it was a hack to stop us from
> > mangling SCSI-3 CDB's.  We fixed the mid-layer not to require the hack
> > by only setting the CDB[1] lun field for SCSI-1 and SCSI-2 devices (as
> > the standards mandate).  What's the actual problem?  No SCSI-1 or SCSI-2
> > device should have any vendor specific CDBs that uses these bits in
> > CDB[1].
> 
> Unfortunately, reality appears to disagree with the last "should".  I've
> personally seen devices with vendor-specific commands that want to control
> CDB[1] in SCSI-2.

Which device and command?  It isn't some vendor who screwed up SCSI-3
compliance and then decided to "fix" it by only claiming SCSI-2, is it?

> I didn't know it was removed; I only know what Timothy Thelin told me.  Can
> we get the feature back?

Not at all easily ... changes to support it would have to thread through
several structures in both the block layer and the scsi subsystem.

James


