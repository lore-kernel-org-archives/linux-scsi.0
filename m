From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Wed, 6 Aug 2014 12:32:33 -0700
Message-ID: <20140806193233.GA11451@infradead.org>
References: <bug-80711-11613@https.bugzilla.kernel.org/>
 <bug-80711-11613-Y5RedyvzAB@https.bugzilla.kernel.org/>
 <53E22DCB.2070407@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54111 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbaHFTch (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2014 15:32:37 -0400
Content-Disposition: inline
In-Reply-To: <53E22DCB.2070407@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Wed, Aug 06, 2014 at 03:29:47PM +0200, Douglas Gilbert wrote:
> If not and since I'm told black lists and the like won't
> work, my advice for the record is to use FreeBSD or Windows
> for tools that need this capability.

I doubt either of them forces users to hack up flags for these cases.

At least for windows I suspect it just never sends the LUN encoded
in the CDB and treats USB devices special instead of our insistance
on pretending they are SCSI-2.

Maybe some of the USB people have on the wire traces or access to
device or windows documentation on this?

