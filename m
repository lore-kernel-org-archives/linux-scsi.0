From: "Russell Johnson" <rjohnson@rtlogic.com>
Subject: RE: megaraid battery status questions
Date: Tue, 14 Sep 2004 11:12:49 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <005701c49a7e$0fa11bf0$1e01a8c0@rtlogic.com>
References: <0E3FA95632D6D047BA649F95DAB60E57033BCA20@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eagle.rtlogic.com ([216.87.68.236]:48619 "EHLO
	eagle.rtlogic.com") by vger.kernel.org with ESMTP id S269473AbUINRMy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 13:12:54 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BCA20@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "'Mukker, Atul'" <Atulm@lsil.com>, linux-scsi@vger.kernel.org


> > With my goal to poll raid status and battery status on a
> > periodic basis,
> > does anyone have ideas on what mechanism I can use?  Ioctl?  
> > Other programs?
> 
> If you have an application which issues the corresponding 
> ioctl, the same would work with 2.20.3.1 driver

I was able to get the 2.20.3.1 driver installed and it seems to work fine
now when the 350O firmware is installed.  Apparently the only working
combination is the 2.20.3.1 driver with the 350O firmware.  The older
firmware I had would report battery errors after a short while but this new
firmware hasn't reported an improper battery status yet.

Thanks for your help.



