From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: 24 Mar 2003 10:56:18 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048525041.1749.49.camel@mulgrave>
References: <1048519237.1982.16.camel@mulgrave>
	<Pine.LNX.4.44.0303240827030.3010-100000@home.transmeta.com>
	<20030324165230.GS2371@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030324165230.GS2371@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Linus Torvalds <torvalds@transmeta.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Mon, 2003-03-24 at 10:52, Jens Axboe wrote:
> It's not true, ->ten is set unconditionally and we only fall back to 6
> byte cdb's if we see an ILLEGAL_REQUEST on a READ_10/WRITE_10.
> 
> So the logic is, always assume 10-byte commands. If an incoming request
> cannot be addressed with 10-byte commands, use 16.

Sorry, that was me misreading the fallback logic in sd.c

Ten bytes it is unless we have problems.

James


