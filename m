From: Christoph Hellwig <hch@lst.de>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical
	max_hw_sectors cap")
Date: Tue, 30 Dec 2014 12:28:09 +0100
Message-ID: <20141230112809.GA1360@lst.de>
References: <20141227151319.GA18607@lst.de> <Pine.LNX.4.44L0.1412282200040.24524-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1412282200040.24524-100000@netrider.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Kenneth R. Crudup" <kenny@panix.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

On Sun, Dec 28, 2014 at 10:10:01PM -0500, Alan Stern wrote:
> (Is this a USB device?  Presumably you wouldn't have CC'ed the
> linux-usb and usb-storage mailing lists if it wasn't...)

It's a usb attached device.  From the inquity information and the
product name it looks like a SATA device attached via a usb bridge.

> The only limits usb-storage imposes on max_sectors are those needed to
> work around bugs in the devices' USB bridges.  (Okay, there's also
> something for tape drive devices, but it probably doesn't belong in
> usb-storage -- it should be handled by the SCSI tape driver.)
> 
> If the ATA layer needs to set a limit on max_sectors, why doesn't it
> simply go ahead and do so?

Because the ATA layer doesn't control the device, the bridge does.
And it seems like it doesn't communicate the maximum transfer size
properly.
