From: David Miller <davem@davemloft.net>
Subject: Re: [2.6 patch] sparc: export kmap_atomic_to_page
Date: Sun, 20 Apr 2008 13:28:29 -0700 (PDT)
Message-ID: <20080420.132829.220464348.davem@davemloft.net>
References: <20080414141956.GN6695@cs181133002.pp.htv.fi>
	<20080415.003910.50277238.davem@davemloft.net>
	<20080420201443.GB14788@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36458
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755276AbYDTU21 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Apr 2008 16:28:27 -0400
In-Reply-To: <20080420201443.GB14788@cs181133002.pp.htv.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bunk@kernel.org
Cc: aacraid@adaptec.com, James.Bottomley@HansenPartnership.com, wli@holomorphy.com, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sun, 20 Apr 2008 23:14:43 +0300

> On Tue, Apr 15, 2008 at 12:39:10AM -0700, David Miller wrote:
> > From: Adrian Bunk <bunk@kernel.org>
> >...
> > > <--  snip  -->
> > > 
> > >   MODPOST 1741 modules
> > > ERROR: "kmap_atomic_to_page" [drivers/scsi/aacraid/aacraid.ko] undefined!
> > > ...
> > > make[2]: *** [__modpost] Error 1
> > > 
> > > <--  snip  -->
> > > 
> > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > Applied, thanks Adrian.
> 
> Please drop - aacraid no longer uses it in 2.6.26.

Ok, will do.
