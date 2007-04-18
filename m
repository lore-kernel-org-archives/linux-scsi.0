From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Major qla2xxx regression on sparc64
Date: Wed, 18 Apr 2007 18:16:32 +0100
Message-ID: <20070418171632.GB16471@infradead.org>
References: <20070416.220208.94071670.davem@davemloft.net> <A6970E9A290F3F4682E1EAD0EA14F32BDF5854@AVEXCH2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38178 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992885AbXDRRQf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Apr 2007 13:16:35 -0400
Content-Disposition: inline
In-Reply-To: <A6970E9A290F3F4682E1EAD0EA14F32BDF5854@AVEXCH2.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: David Miller <davem@davemloft.net>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, ema@debian.org

On Tue, Apr 17, 2007 at 11:28:07AM -0700, Seokmann Ju wrote:
> Hello David,
> On Mon 4/16/2007 10:02 PM, David Miller wrote:
> > > I'm in transit for a redeye to NY so I won't be able to modify the 
> > > patch, If you would be amenable to the above, Seokmann, could you 
> > > rework the patch?
> > 
> > Thanks guys.
> Here, I've attached updated patch. Please take this.
> Sorry for late.

I don't think there should be a warning in the sparc case where the
wwn's are stored in the device tree.  This is the way sun intended
the hardware to work on sparc.  

