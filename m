From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Fri, 13 Dec 2002 21:51:13 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021213215113.A16528@infradead.org>
References: <hch@infradead.org> <200212101602.gBAG2Hi02930@localhost.localdomain> <20021211135855.A19325@infradead.org> <1266570000.1039619906@aslan.scsiguy.com> <20021211153935.A23704@infradead.org> <1221760000.1039627865@aslan.btc.adaptec.com> <20021211181745.A30253@infradead.org> <20021212202052.GC8842@redhat.com> <20021213210215.A15074@infradead.org> <20021213212352.GA10883@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021213212352.GA10883@redhat.com>; from dledford@redhat.com on Fri, Dec 13, 2002 at 04:23:52PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Fri, Dec 13, 2002 at 04:23:52PM -0500, Doug Ledford wrote:
> Hmmm...what's the failure mode here?

It complains that it can't reserve the mem regions but still continues to
setup, download sequencer code, and even register scsi3ff.

