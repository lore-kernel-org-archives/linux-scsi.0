From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating
	SMART/ATA-Security in usb-storage driver
Date: Sun, 06 Nov 2005 17:15:28 -0600
Message-ID: <1131318928.3316.25.camel@mulgrave>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com>
	 <1131130707.3532.45.camel@mulgrave>
	 <20051104203004.GF12384@one-eyed-alien.net>
	 <1131137395.3532.57.camel@mulgrave>
	 <20051105235522.GA21733@one-eyed-alien.net>
	 <1131238146.9430.7.camel@mulgrave>
	 <20051106215856.GA28452@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:13246 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932288AbVKFXPf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Nov 2005 18:15:35 -0500
In-Reply-To: <20051106215856.GA28452@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Timothy Thelin <Timothy.Thelin@wdc.com>, t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>

On Sun, 2005-11-06 at 13:58 -0800, Matthew Dharm wrote:
> I've been recommending this flag to people as recently as 6 months ago
> (i.e. the last time someone asked me).   It comes up 2-3 times a year.
> 
> The last time it came up, the device set SCSI_2.

OK ... if you send a patch to add it back  I'll look it over ... but it
needs to be clean;  I'm betting it needs a huge amount of changes that
would thread through both SCSI and block (so Jens will need to ack it
too).

James


