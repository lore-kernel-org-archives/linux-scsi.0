From: Oliver Xymoron <oxymoron@waste.org>
Subject: Re: Re: about scsi_hostlist
Date: Sun, 17 Nov 2002 23:13:02 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021118051302.GD20171@waste.org>
References: <200211172304.gAHN4h99024044@leviathan.ele.uri.edu> <1037576902.5554.6.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1037576902.5554.6.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ming Zhang <mingz@ele.uri.edu>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sun, Nov 17, 2002 at 11:48:22PM +0000, Alan Cox wrote:
> > basically, an iscsi target tell clients how many scsi devices it has, then 
> 
> Thats broken (like the word wrap on your mailer btw)
> 
> How many scsi devices it has _when_. Controllers and disks are all hot
> pluggable. 

iSCSI has notification/discovery events. There's no reason the target
side of iSCSI can't be completely userspace and can interface with
hotplug. It wants per-device configuration anyway for access control
and authentication.

-- 
 "Love the dolphins," she advised him. "Write by W.A.S.T.E.." 
