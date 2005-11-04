From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating
	SMART/ATA-Security in usb-storage driver
Date: Fri, 04 Nov 2005 14:53:16 -0600
Message-ID: <1131137596.3532.61.camel@mulgrave>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3A@WDSCEXBECL03.sc.wdc.com>
	 <20051102234532.GC26148@one-eyed-alien.net>
	 <1131077287.3117.22.camel@mulgrave>
	 <20051104172844.GA12384@one-eyed-alien.net>
	 <1131129230.3532.40.camel@mulgrave>
	 <20051104203034.GG12384@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20051104203034.GG12384@one-eyed-alien.net>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Timothy Thelin <Timothy.Thelin@wdc.com>, t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2005-11-04 at 12:30 -0800, Matthew Dharm wrote:
> Would the block layer really have to change much if the commands only come
> from SG_IO?

Yes, since the CDB[1] addition is done in scsi_dispatch_cmd() all you
really have access to there is the command (and through it the device
and host).  So a blacklist would be not too much work to implement but
actually making the SG_IO flag work would be quite large because it has
to be connected first to the request and then to the command.

James


