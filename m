From: Bob Tracy <rct@gherkin.frus.com>
Subject: Re: Interest in a driver for PCMCIA Bus toaster (New Media) with advansys chip set?
Date: Sun, 15 Aug 2010 08:17:22 -0500
Message-ID: <20100815131722.GA11666@gherkin.frus.com>
References: <201008141934.05664.development.stefan@alice.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:54844 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757572Ab0HOQtu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Aug 2010 12:49:50 -0400
Content-Disposition: inline
In-Reply-To: <201008141934.05664.development.stefan@alice.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Schmitt <development.stefan@alice.de>
Cc: linux-scsi@vger.kernel.org

On Sat, Aug 14, 2010 at 07:34:05PM +0200, Stefan Schmitt wrote:
> the card is labelled PS: 404-15-02A. As much as I could see, there
> is no linux driver available.
> 
>         Product Name:   PCMCIA Bus Toaster SCSI Adapter
>         Identification: manf_id: 0x10cd card_id: 0x0001
>                  function: 8 (SCSI)
>                  prod_id(1): "PCMCIA Bus Toaster" (0x590031a6)
>                  prod_id(2): "SCSI Adapter" (0x96269fcd)
> 
> I have an initial version of driver code (for the 2.6 kernel). I could send 
> the code to someone more experienced if there is interest.

I suspect this will turn out as it did for me when I tried to do
something similar with the Symbios Logic 53c500 version of the New Media
Bus Toaster :-).  Since you presumably have access to the card, you're in
the best position to do further development and testing on the driver.

Maybe the other one or two people running Linux who have one of these
beasts will come forward and volunteer to help with the testing, but the
53c500 version was supposedly newer (circa 1997), so the odds aren't
good.  Even so, I'd say please submit the driver.  I wouldn't trade my
experience with the driver development process for anything: it was fun
and I learned a lot.

--Bob
