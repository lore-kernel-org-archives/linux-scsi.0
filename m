From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Fri, 13 Dec 2002 21:02:15 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021213210215.A15074@infradead.org>
References: <hch@infradead.org> <200212101602.gBAG2Hi02930@localhost.localdomain> <20021211135855.A19325@infradead.org> <1266570000.1039619906@aslan.scsiguy.com> <20021211153935.A23704@infradead.org> <1221760000.1039627865@aslan.btc.adaptec.com> <20021211181745.A30253@infradead.org> <20021212202052.GC8842@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hch by phoenix.infradead.org with local (Exim 4.10)
	id 18Mwwp-0003wZ-00
	for linux-scsi@vger.kernel.org; Fri, 13 Dec 2002 21:02:15 +0000
Content-Disposition: inline
In-Reply-To: <20021212202052.GC8842@redhat.com>; from dledford@redhat.com on Thu, Dec 12, 2002 at 03:20:52PM -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thu, Dec 12, 2002 at 03:20:52PM -0500, Doug Ledford wrote:
> On Wed, Dec 11, 2002 at 06:17:46PM +0000, Christoph Hellwig wrote:
> > 
> > Yupp, it currently crashes when I have both compiled in.  Dough, any chance
> > you could fix that?  A PCI driver is not supposed to stop over already
> > claimed device.
> 
> If you've got a test machine, the attached patch would I think fix the 
> problem.  Let me know if it does in fact work for you and I'll commit it 
> to the tree.

Still doesn't work.  I think you really need to set and check the driver
field like justin suggested.

