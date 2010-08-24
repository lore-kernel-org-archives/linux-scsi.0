From: Stefan Schmitt <development.stefan@alice.de>
Subject: Re: Interest in a driver for PCMCIA Bus toaster (New Media) with advansys chip set?
Date: Tue, 24 Aug 2010 09:12:07 +0200
Message-ID: <201008240912.08096.development.stefan@alice.de>
References: <201008141934.05664.development.stefan@alice.de> <20100815131722.GA11666@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:48061 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0HXIMg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2010 04:12:36 -0400
In-Reply-To: <20100815131722.GA11666@gherkin.frus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-scsi@vger.kernel.org

On Sunday 15 August 2010 at 15:17:22 Bob Tracy wrote:
> On Sat, Aug 14, 2010 at 07:34:05PM +0200, Stefan Schmitt wrote:
> > the card is labelled PS: 404-15-02A. As much as I could see, there
> > is no linux driver available.
> >
> >         Product Name:   PCMCIA Bus Toaster SCSI Adapter
> >         Identification: manf_id: 0x10cd card_id: 0x0001
> >                  function: 8 (SCSI)
> >                  prod_id(1): "PCMCIA Bus Toaster" (0x590031a6)
> >                  prod_id(2): "SCSI Adapter" (0x96269fcd)
> >
> > I have an initial version of driver code (for the 2.6 kernel). I could
> > send the code to someone more experienced if there is interest.
> 
> I suspect this will turn out as it did for me when I tried to do
> something similar with the Symbios Logic 53c500 version of the New Media
> Bus Toaster :-).  Since you presumably have access to the card, you're in
> the best position to do further development and testing on the driver.
> 
> Maybe the other one or two people running Linux who have one of these
> beasts will come forward and volunteer to help with the testing, but the
> 53c500 version was supposedly newer (circa 1997), so the odds aren't
> good.  Even so, I'd say please submit the driver.  I wouldn't trade my
> experience with the driver development process for anything: it was fun
> and I learned a lot.
> 
> --Bob
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

In case someone is interested: the code is available here:

http://www.alice-dsl.net/development.stefan/bustoaster2_cs/bustoaster2_cs.tgz

Stefan
