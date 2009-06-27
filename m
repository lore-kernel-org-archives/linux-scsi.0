From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] SCSI: userspace cannot use scsi_command_size_tbl,
	COMMAND_SIZE and scsi_device_type
Date: Sat, 27 Jun 2009 12:28:21 -0600
Message-ID: <20090627182821.GC5480@parisc-linux.org>
References: <1246122359.32198.7.camel@hpdv5.satnam> <1246123628.3990.19.camel@mulgrave.site> <1246125388.32198.14.camel@hpdv5.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54764 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbZF0S2T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2009 14:28:19 -0400
Content-Disposition: inline
In-Reply-To: <1246125388.32198.14.camel@hpdv5.satnam>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Sam Ravnborg <sam@ravnborg.org>, Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, Jun 27, 2009 at 11:26:28PM +0530, Jaswinder Singh Rajput wrote:
> > On Sat, 2009-06-27 at 22:35 +0530, Jaswinder Singh Rajput wrote:
> > > userspace cannot use scsi_command_size_tbl, COMMAND_SIZE
> > > and scsi_device_type defined in kernel

When did we start exporting include/scsi to userspace?  I thought glibc
had its own separate definitions.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
