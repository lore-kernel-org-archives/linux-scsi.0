From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] clean up scsi documentation
Date: Mon, 11 Nov 2002 15:42:56 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021111154256.A24447@infradead.org>
References: <200211111633.55526@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211111633.55526@bilbo.math.uni-mannheim.de>; from eike@bilbo.math.uni-mannheim.de on Mon, Nov 11, 2002 at 04:33:55PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike@bilbo.math.uni-mannheim.de>
Cc: linux-scsi@vger.kernel.org

On Mon, Nov 11, 2002 at 04:33:55PM +0100, Rolf Eike Beer wrote:
> Hi,
> 
> here are my patches to clean up the scsi documentation. It is split in three
> parts:
> 
> 0) Do the work. A small script that does the following things:
> -create Documentation/scsi/
> -move all the scsi documentation from Documentation/ and drivers/scsi/ to this
> location
> -kill ChangeLog.serverraid. It's a duplication from ChangeLog.ips but is
> missing some bits (got ok from maintainer to do this)
> -rename README.drivername to drivername.txt which is more common in
> Documentation/*
> NOTE: start this script on the top level of the source tree (/usr/src/linux or
> whereever you put it).
> 
> 1) Fix up references. A patch doing the following:
> -fix up all the references (hope I got them all)
> -introduce Documentation/scsi/00-INDEX
> 
> 2) Clean up. Just a bit cosmetics:
> -kill unneeded trailing new lines
> -kill one not-ascii character from FlashPoint.txt
> -kill unneeded patch instruction from cpqfc.txt: noone needs this because the
> driver is already in the kernel as everybody can see.

Sounds good to me.  Would be nice to separate the steps so BK notices
the file moves and keeps history.

