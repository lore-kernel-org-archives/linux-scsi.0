From: David Miller <davem@davemloft.net>
Subject: Re: Major qla2xxx regression on sparc64
Date: Wed, 18 Apr 2007 13:12:21 -0700 (PDT)
Message-ID: <20070418.131221.35665053.davem@davemloft.net>
References: <20070416.220208.94071670.davem@davemloft.net>
	<A6970E9A290F3F4682E1EAD0EA14F32BDF5854@AVEXCH2.qlogic.org>
	<20070418171632.GB16471@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56633
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992486AbXDRUMS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Apr 2007 16:12:18 -0400
In-Reply-To: <20070418171632.GB16471@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: seokmann.ju@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, ema@debian.org

From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 18 Apr 2007 18:16:32 +0100

> On Tue, Apr 17, 2007 at 11:28:07AM -0700, Seokmann Ju wrote:
> > Hello David,
> > On Mon 4/16/2007 10:02 PM, David Miller wrote:
> > > > I'm in transit for a redeye to NY so I won't be able to modify the 
> > > > patch, If you would be amenable to the above, Seokmann, could you 
> > > > rework the patch?
> > > 
> > > Thanks guys.
> > Here, I've attached updated patch. Please take this.
> > Sorry for late.
> 
> I don't think there should be a warning in the sparc case where the
> wwn's are stored in the device tree.  This is the way sun intended
> the hardware to work on sparc.  

Yep, that's the main point.

Sun provides device parameters via openprom properties in lieu
of existing mechanisms chip vendors usually use for this on
other platforms such as NVRAM and the BIOS.

They do this for just about every scsi, networking, and video
chip.  It works this way on PowerPC as well.
