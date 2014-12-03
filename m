From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 00/12] nobody loves the advansys driver
Date: Wed, 3 Dec 2014 16:34:48 +0100
Message-ID: <201412031634.48711.linux@rainbow-software.org>
References: <1417607105-85455-1-git-send-email-hare@suse.de> <20141203152141.GA6175@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:58903 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaLCPfd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2014 10:35:33 -0500
In-Reply-To: <20141203152141.GA6175@lst.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On Wednesday 03 December 2014, Christoph Hellwig wrote:
> Thanks for looking into this old driver.
>
> If you've got a few spare cycles it might make sense to simply split
> the "wide board" support out - the driver literally is two different
> drivers with an if/else section in every method for the totally
> different narrow vs wide boards.  Having at least a clean and simple
> driver for the newer wide boards would be good, and narrow ones are
> probably old enough that we can let the driver for those fade away..

I have an ASB-3940UA (bought around 2000) and use it for scanner so I can test 
patches.
The driver was working fine so I never had to look at the code. Now I see that 
it's 12K lines long :( Converting that to something simple would require a 
lot of work.

-- 
Ondrej Zary
