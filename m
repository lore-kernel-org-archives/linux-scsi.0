From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: AIC94xx SAS question.
Date: Mon, 28 Apr 2008 21:46:57 -0400
Message-ID: <20080429014657.GA17521@animx.eu.org>
References: <20080421231940.GB5656@animx.eu.org> <4812B66A.5000105@hopnet.net> <20080426145649.GA8848@animx.eu.org> <1209225384.3113.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:60796 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbYD2Bq7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Apr 2008 21:46:59 -0400
Content-Disposition: inline
In-Reply-To: <1209225384.3113.19.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> > I can understand this from the point of the distrobution of the linux
> > kernel, but it still can be done.  If there were a patch or something that
> > would convert the file, that's all I care.  This for me would be preferred.
> 
> There is certainly a way to do this: all you really need to do is to
> render the firmware into hex as a character array, compile the array
> with the driver and return a pointer to the first byte at the
> request_firmware call.

I know I can make a .h file with the firmware in it.  I might beable to do
the other change as well, not sure yet.  I'm not a kernel hacker.

> The practical reason it's no-longer done (apart from the annoyance it
> causes debian) is simply that the file is huge and the firmware seems to
> change quite a lot.  For the qla2xxx driver (whose firmware, admittedly
> is larger than aic94xx) it used to result in a 4MB patch every time
> there was a tiny change to the file.

It would be nice if someone had a patch that would include a .h file to the
driver and the .h can be generated from whatever firmware is wanted.

If I ever decide to redesign my system, I may have a go at this.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
