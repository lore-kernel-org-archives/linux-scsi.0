From: David Miller <davem@davemloft.net>
Subject: Re: Major qla2xxx regression on sparc64
Date: Tue, 17 Apr 2007 11:56:02 -0700 (PDT)
Message-ID: <20070417.115602.35506934.davem@davemloft.net>
References: <20070417024107.GE16469@dmccrory-d810.qlogic.org>
	<20070416.220208.94071670.davem@davemloft.net>
	<A6970E9A290F3F4682E1EAD0EA14F32BDF5854@AVEXCH2.qlogic.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32785
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1031131AbXDQS4A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Apr 2007 14:56:00 -0400
In-Reply-To: <A6970E9A290F3F4682E1EAD0EA14F32BDF5854@AVEXCH2.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seokmann.ju@qlogic.com
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, ema@debian.org

From: "Seokmann Ju" <seokmann.ju@qlogic.com>
Date: Tue, 17 Apr 2007 11:28:07 -0700

> Hello David,
> On Mon 4/16/2007 10:02 PM, David Miller wrote:
> > > I'm in transit for a redeye to NY so I won't be able to modify the 
> > > patch, If you would be amenable to the above, Seokmann, could you 
> > > rework the patch?
> > 
> > Thanks guys.
> Here, I've attached updated patch. Please take this.
> Sorry for late.

Actually, I misunderstood the patch.

If SPARC provides the port and node WWN numbers in the OFW properties
the driver should load properly.

NAK, I reject this patch.
