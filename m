From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Thu, 12 Dec 2002 14:06:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <370210000.1039727206@aslan.btc.adaptec.com>
References: <hch@infradead.org>
 <200212101602.gBAG2Hi02930@localhost.localdomain>
 <20021211135855.A19325@infradead.org>
 <1266570000.1039619906@aslan.scsiguy.com>
 <20021211153935.A23704@infradead.org>
 <1221760000.1039627865@aslan.btc.adaptec.com>
 <20021211181745.A30253@infradead.org> <20021212202052.GC8842@redhat.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021212202052.GC8842@redhat.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

> On Wed, Dec 11, 2002 at 06:17:46PM +0000, Christoph Hellwig wrote:
>> 
>> Yupp, it currently crashes when I have both compiled in.  Dough, any
>> chance you could fix that?  A PCI driver is not supposed to stop over
>> already claimed device.
> 
> If you've got a test machine, the attached patch would I think fix the 
> problem.  Let me know if it does in fact work for you and I'll commit it 
> to the tree.

I would have to review the aic7xxx driver's probe and attach routine
to see if in the case of aic7xxx_old probing first all is well.  If you
could somehow get pci_dev->driver to get set, in the above load order,
aic7xxx would never even have its probe routine called.

--
Justin
