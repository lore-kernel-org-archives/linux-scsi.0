From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Wed, 11 Dec 2002 10:31:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1221760000.1039627865@aslan.btc.adaptec.com>
References: <hch@infradead.org>
 <200212101602.gBAG2Hi02930@localhost.localdomain>
 <20021211135855.A19325@infradead.org>
 <1266570000.1039619906@aslan.scsiguy.com>
 <20021211153935.A23704@infradead.org>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021211153935.A23704@infradead.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

>> >   - fix kbuild integration
>> 
>> Can you explain what failed before?  I don't mind using aic7xxx-y
>> or aic79xx-y instead of *-obj, but I would like to understand what
>> bug this fixes.
> 
> AIC79xx support could be selected without PCI beeing set, letting
> the makefile silently not build it

Okay.  Sine the choice directive is now gone, is there a compelling reason
to put the "old" aic7xxx driver Kconfig directives in the same Kconfig
file as the new driver?  It is kind of nice to have the separation since
Adaptec cannot support the old driver.  I also take it that you were also
unable to make the choice directive do the right thing?  That was the
original reason for removing the "old driver" Kconfig directives.  The
way your patch stands now, I don't believe there is anything to prevent
both drivers from being compiled statically into the kernel.  If so, the
resulting kernel will not boot.

--
Justin

