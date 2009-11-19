From: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Subject: RE: Bug 14579
Date: Thu, 19 Nov 2009 12:11:52 +0100
Message-ID: <1258629112.8918.45.camel@muchoki.zuhause>
References: <20091111160220.GC5705@TechFak.Uni-Bielefeld.DE>
	 <20091112225825.GA20808@TechFak.Uni-Bielefeld.DE>
	 <0D1E8821739E724A86F4D16902CE275C1C93C04462@inbmail01.lsi.com>
	 <20091117142242.GA15638@TechFak.Uni-Bielefeld.DE>
	 <0D1E8821739E724A86F4D16902CE275C1C93C74A49@inbmail01.lsi.com>
	 <20091118133909.GD16440@TechFak.Uni-Bielefeld.DE>
	 <0D1E8821739E724A86F4D16902CE275C1C93C74BD4@inbmail01.lsi.com>
	 <1258625851.8918.20.camel@muchoki.zuhause>
	 <0D1E8821739E724A86F4D16902CE275C1C93C74C80@inbmail01.lsi.com>
	 <1258627720.8918.33.camel@muchoki.zuhause>
	 <0D1E8821739E724A86F4D16902CE275C1C93C74C97@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:60023 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716AbZKSLKb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2009 06:10:31 -0500
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1C93C74C97@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, sfrey@techfak.uni-bielefeld.de

Am Donnerstag, den 19.11.2009, 16:28 +0530 schrieb Desai, Kashyap:
> > It's all in Bug #14579, see
> > http://bugzilla.kernel.org/show_bug.cgi?id=14579
> > 
> > Basically, after a while writing to the tape drive that is attached to
> > the LSI controller, the bus either resets itself without finding the
> > tape drives again, or we get an oops and the system crashes. This is a
> > seperate problem from the one we have with the Adaptec RAID on 2.6.32,
> > that is the reason why we opened two bugs.
> > 
> Looking at oops message attached to bug14579, I am still unable to map
> anything which might be related to LSI driver, in sort I am not
> getting any pointers related to fusion driver from OOPS message .
> Better way to provide Oops will be console redirect. 

Okay, now I see why you don't see it being LSI related. The problem
appears only ever when writing to a tape (regardless of which one of the
two tape drives we use) or sending commands to the tape robot (all
devices are connected to the LSI controller) and is reproducible, that's
the reason we deducted it has something to do with the LSI driver or
linux scsi subsystem.
Solaris seemed to have worked fine, but that's a route we're unwilling
to go at the moment. Unfortunatly, we don't have another HBA for testing
to verify this.

Thanks for the sources, we'll build and test it. You can expect to hear
from us again early next week. We'll also try to capture the full
console output next time.

-- 
Kind regards,
Lukas Kolbe


