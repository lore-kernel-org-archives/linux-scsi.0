From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Date: Tue, 31 Jul 2007 07:16:22 -0700
Message-ID: <1185891382.2750.8.camel@laptopd505.fenrus.org>
References: <20070705194909.337398431@intel.com>
	 <20070705130518.135e4e3c.kristen.c.accardi@intel.com>
	 <46AE12B6.6090408@garzik.org>  <46AED656.8070407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761473AbXGaOQy@vger.kernel.org>
In-Reply-To: <46AED656.8070407@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

On Tue, 2007-07-31 at 15:27 +0900, Tejun Heo wrote:
> Jeff Garzik wrote:
> > Any chance the SCSI peeps could ACK this, and then let me include it in
> > the ALPM patchset in the libata tree?
> 
> ATA link PS is pretty complex with HIPM, DIPM and AHCI ALPM.  I'm not
> sure whether this three level knob would be sufficient. 

adding more levels later is easy.

>  It might be
> good enough if we're gonna develop extensive in-kernel black/white list
> specifying which method works on which combination but my gut tells me
> that it's best left to userland (probably in the form of per-notebook PS
> profile).

either sucks. AHCI ALPM ought to work if it's supported; it's what other
operating systems also use... 
> 
> Adding to the fun, there are quite a few broken devices out there which
> act weirdly when link PS actions are taken.

do you have any specific examples that act funny with the patch in
question here? (the patch tries to be careful, previous patches weren't
always so please test this patch before claiming the concept as a whole
is broken)
> 
> Also, I generally don't think AHCI ALPM is a good idea.  It doesn't have
> 'cool down' period before entering PS state

that's a chipset implementation decision.... not part of the
spec/technology per se.
