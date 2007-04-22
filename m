From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Major qla2xxx regression on sparc64
Date: Sun, 22 Apr 2007 15:31:21 +0100
Message-ID: <20070422143121.GA10947@infradead.org>
References: <20070416.123743.07452378.davem@davemloft.net> <20070416200857.GH10822@andrew-vasquezs-computer.local> <20070418171346.GA16471@infradead.org> <20070418.131054.70219428.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46203 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030922AbXDVOb0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Apr 2007 10:31:26 -0400
Content-Disposition: inline
In-Reply-To: <20070418.131054.70219428.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, ema@debian.org

On Wed, Apr 18, 2007 at 01:10:54PM -0700, David Miller wrote:
> From: Christoph Hellwig <hch@infradead.org>
> Date: Wed, 18 Apr 2007 18:13:46 +0100
> 
> > Note that I expect Sun put in the invalid ROM intentionally, as we have
> > similar cases with other cards that have totally messed up ROMs in
> > Sun-branded versions.  Personally I think that's an utterly bad decision
> > from Sun's side, but we'll have to live with this.
> 
> The way configuration paramters are provided on Sun systems is via
> openfirmware properties, this is how they do everything and that is
> why they never setup the NVRAMs on various chips.
> 
> This happens on PowerPC too.  One of many examples is determining the
> clock parameters of the ATI Radeon graphics card, it's provided as an
> openfirmware property not in some config area in the BIOS.
> 
> We can either be anti-social and _demand_ that these systems get their
> NVRAMs fixed, which in reality will never happen and is totally
> unreasonable, or we can say ok this is how we get the information we
> need on these platforms we'll look for it there.

Personally I think it is reasonable to expect manufacturer-provided
config space to always be in the same place, regardless what kind
of executable rom is there.  Then again most vendors seem to think
it's unresonable, and even if it wasn't we'll have to make sure our
drivers work with whatever it out there - so this discussion is
rather moot.
