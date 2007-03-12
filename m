From: Christoph Hellwig <hch@infradead.org>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 08:18:51 +0000
Message-ID: <20070312081851.GA14831@infradead.org>
References: <45F48809.2060908@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50778 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965289AbXCLISw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Mar 2007 04:18:52 -0400
Content-Disposition: inline
In-Reply-To: <45F48809.2060908@emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <ric@emc.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>

On Sun, Mar 11, 2007 at 06:51:53PM -0400, Ric Wheeler wrote:
> 
> During the recent IO/FS workshop, we spoke briefly about the coming 
> change to a 4k sector size for disks on linux. If I recall correctly, 
> the general feeling was that the impact was not significant since we 
> already do most file system IO in 4k page sizes and should be fine as 
> long as we partition drives correctly and avoid non-4k aligned partitions.
> 
> Are there other concerns in the IO or FS stack that we should bring up 
> with vendors?  I have been asked to summarize the impact of 4k sectors 
> on linux  for a disk vendor gathering and want to make sure that I put 
> all of our linux specific items into that summary...

The FS stack and higher levels of the I/O stack should be mostly ready.
The S/390 DASDs are commonly used with 4k sector sizes, and we've had
the occasional 2k sector SCSI MO device aswell.  It would be nice to
get samples of large sector size ATA devices into the hands of developers
to do real world testing of the whole stack.
