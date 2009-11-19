From: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Subject: RE: Bug 14579 (was: RE: Bug 14579 -  Devices disappear... and Bug
 14577 - Data corruption with Adaptec)
Date: Thu, 19 Nov 2009 11:48:40 +0100
Message-ID: <1258627720.8918.33.camel@muchoki.zuhause>
References: <20091111160220.GC5705@TechFak.Uni-Bielefeld.DE>
	 <20091112225825.GA20808@TechFak.Uni-Bielefeld.DE>
	 <0D1E8821739E724A86F4D16902CE275C1C93C04462@inbmail01.lsi.com>
	 <20091117142242.GA15638@TechFak.Uni-Bielefeld.DE>
	 <0D1E8821739E724A86F4D16902CE275C1C93C74A49@inbmail01.lsi.com>
	 <20091118133909.GD16440@TechFak.Uni-Bielefeld.DE>
	 <0D1E8821739E724A86F4D16902CE275C1C93C74BD4@inbmail01.lsi.com>
	 <1258625851.8918.20.camel@muchoki.zuhause>
	 <0D1E8821739E724A86F4D16902CE275C1C93C74C80@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:42688 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754938AbZKSKrT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2009 05:47:19 -0500
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1C93C74C80@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfrey@techfak.uni-bielefeld.de" <sfrey@techfak.uni-bielefeld.de>

Am Donnerstag, den 19.11.2009, 16:00 +0530 schrieb Desai, Kashyap:
> 
> > -----Original Message-----
> > From: Lukas Kolbe [mailto:lkolbe@techfak.uni-bielefeld.de]
> > Sent: Thursday, November 19, 2009 3:48 PM
> > To: Desai, Kashyap
> > Cc: linux-scsi@vger.kernel.org; sfrey@techfak.uni-bielefeld.de
> > Subject: Bug 14579 (was: RE: Bug 14579 - Devices disappear... and Bug
> > 14577 - Data corruption with Adaptec)
> > 
> > Am Donnerstag, den 19.11.2009, 10:43 +0530 schrieb Desai, Kashyap:
> > > OK. So I get it now. You are working to solve major issue which is
> > > related to your RAID 60 + Adaptec controller. If you want to upgrade
> > > LSI driver, we can always go for latest driver. I can provide you
> > > latest driver source tar ball.  Back porting to 2.6.30 is fine.
> > 
> > That would be great, thank you. It seems the Adaptec-problem will still
> > take a while to debug, so if we can get further with the LSI issue it
> > would be much appreciated. It might take a few days of testing after we
> > build 2.6.30 with the new mtpfusion.
> > 
> I think, without solving one issue (Adaptec related), I am not in
> position to understand what is an issue w.r.t LSI ? Pls clarify. If
> you can provide me Logs for LSI driver and provide me pointer to look
> inside, I can do something on this.

It's all in Bug #14579, see
http://bugzilla.kernel.org/show_bug.cgi?id=14579

Basically, after a while writing to the tape drive that is attached to
the LSI controller, the bus either resets itself without finding the
tape drives again, or we get an oops and the system crashes. This is a
seperate problem from the one we have with the Adaptec RAID on 2.6.32,
that is the reason why we opened two bugs. 

If you can provide us with the current mptfusion, we can build it for
2.6.30 and test wether the bus reset and/or oops do still happen. If
they don't, you made a few people very happy :)

-- 
Kind regards,
Lukas


