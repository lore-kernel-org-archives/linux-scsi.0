From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SCSI in a post 2.6.0 world
Date: Thu, 18 Dec 2003 10:31:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031218153128.GA5389@gtf.org>
References: <1071758885.2430.37.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([63.247.75.124]:31629 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S265213AbTLRPba (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2003 10:31:30 -0500
Content-Disposition: inline
In-Reply-To: <1071758885.2430.37.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Dec 18, 2003 at 09:48:05AM -0500, James Bottomley wrote:
> With the announcement of 2.6.0, I've dusted off the scsi-misc-2.7 tree
> at
> 
> bk://linux-scsi.bkbits.net/scsi-misc-2.7
> 
> I'm afraid, until the new merge criteria are announced, you can't assume
> it will contain the actual changesets that will be merged (I may need to
> take it apart and redo it),  but it's a good start for people who want
> to begin ongoing SCSI development again.

FWIW, I'm going to be working in this area, for 2.7.

My plan has two main goals,

(a) move the low-level driver API "up" from SCSI, to be available to all
block drivers.
(b) consolidate "personality" code:  foodisk.c will drive
PATA/SATA/SCSI/RAID/whatever disks.  foocdrom.c will drive cd-roms.
footape.c will drive tapes.

The overall goal is to have all low-level block drivers at the same
level, simply utilizing subsystem-specific hooks to provide
SCSI-specific behavior.

And all this will be accomplished through evolution of existing code.
You have convinced me that SCSI doesn't need yet another rewrite ;-) so
I will be leveraging all the work that's gone into SCSI in 2.6...

Whenever you hear me mention "/dev/disk", the above is what I am
referring to.

FWIW.

	Jeff



