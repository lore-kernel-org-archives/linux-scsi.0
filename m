From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 1 Mar 2005 22:19:14 +0000
Message-ID: <20050301221914.GB5742@infradead.org>
References: <OF00F39C19.AE2C12A8-ON88256FB7.00641755-88256FB7.0065149B@us.ibm.com> <1109702227.6293.137.camel@laptopd505.fenrus.org> <m1d5ujp0dx.fsf@muc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:22165 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262099AbVCAWTS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 17:19:18 -0500
Content-Disposition: inline
In-Reply-To: <m1d5ujp0dx.fsf@muc.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: Arjan van de Ven <arjan@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, iscsitarget-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Tue, Mar 01, 2005 at 09:38:34PM +0100, Andi Kleen wrote:
> Arjan van de Ven <arjan@infradead.org> writes:
> >
> > You want to *use* the kernel pagecache as much as you can. You do so by
> > using mmap and such, and msync to force content to disk. That uses the
> 
> Last time I checked you couldn't mmap block devices. Has this changed
> now?  Could be a problem for an iSCSI target.

Since 2.4.10 you can mmap block devices.
