From: Oliver Xymoron <oxymoron@waste.org>
Subject: Re: [PATCH] SCSI hotplug support
Date: Mon, 14 Oct 2002 14:11:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021014191106.GD11375@waste.org>
References: <mdharm-scsi@one-eyed-alien.net> <20021014103059.C9725@one-eyed-alien.net> <200210141739.g9EHdYX03416@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210141739.g9EHdYX03416@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: andersen@codepoet.org, linux-scsi@vger.kernel.org

yOn Mon, Oct 14, 2002 at 10:39:34AM -0700, James Bottomley wrote:
> mdharm-scsi@one-eyed-alien.net said:
> > In userspace, something should get a new device notification and
> > decide what to do with the new device. Format?  Mount?  Ignore?  But,
> > it needs a /dev node to be able to handle the device, therefore the
> > kernel must do the work up to that point. 
> 
> SCSI was designed with this in mind.  The add/remove-single-device API works 
> before a dev node exists.  It expects four numeric parameters 
> (host,channel,pun and lun), and will do the inquiry and attach the correct 
> SCSI upper layer drivers.

Which works most of the time, but I'm pretty sure I've seen some ugly
races here when adding, oh, 40-50 devices at a go. Haven't looked at
this recently though.

-- 
 "Love the dolphins," she advised him. "Write by W.A.S.T.E.." 
