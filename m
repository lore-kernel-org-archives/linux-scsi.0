From: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Subject: Bug 14579 (was: RE: Bug 14579 -  Devices disappear... and Bug
 14577 - Data corruption with Adaptec)
Date: Thu, 19 Nov 2009 11:17:31 +0100
Message-ID: <1258625851.8918.20.camel@muchoki.zuhause>
References: <20091111160220.GC5705@TechFak.Uni-Bielefeld.DE>
	 <20091112225825.GA20808@TechFak.Uni-Bielefeld.DE>
	 <0D1E8821739E724A86F4D16902CE275C1C93C04462@inbmail01.lsi.com>
	 <20091117142242.GA15638@TechFak.Uni-Bielefeld.DE>
	 <0D1E8821739E724A86F4D16902CE275C1C93C74A49@inbmail01.lsi.com>
	 <20091118133909.GD16440@TechFak.Uni-Bielefeld.DE>
	 <0D1E8821739E724A86F4D16902CE275C1C93C74BD4@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:35808 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755337AbZKSKQK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2009 05:16:10 -0500
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1C93C74BD4@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, sfrey@techfak.uni-bielefeld.de

Am Donnerstag, den 19.11.2009, 10:43 +0530 schrieb Desai, Kashyap:
> OK. So I get it now. You are working to solve major issue which is
> related to your RAID 60 + Adaptec controller. If you want to upgrade
> LSI driver, we can always go for latest driver. I can provide you
> latest driver source tar ball.  Back porting to 2.6.30 is fine.

That would be great, thank you. It seems the Adaptec-problem will still
take a while to debug, so if we can get further with the LSI issue it
would be much appreciated. It might take a few days of testing after we
build 2.6.30 with the new mtpfusion. 

-- 
Lukas Kolbe



