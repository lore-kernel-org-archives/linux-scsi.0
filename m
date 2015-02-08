From: "Kenneth R. Crudup" <kenny@panix.com>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical max_hw_sectors
 cap")
Date: Sun, 8 Feb 2015 14:11:52 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1502081409460.4188@tosh-p75a>
References: <Pine.LNX.4.44L0.1501191050320.23741-100000@netrider.rowland.org>
Reply-To: "Kenneth R. Crudup" <kenny@panix.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1501191050320.23741-100000@netrider.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@lst.de>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org


On Mon, 19 Jan 2015, Alan Stern wrote:
...

If anyone (still?) cares about this bug, commit 3a9794d3 ("sd: Fix max
transfer length for 4k disks") fixes it, with no patches required.

	-Kenny

-- 
Kenneth R. Crudup  Sr. SW Engineer, Scott County Consulting, Silicon Valley
