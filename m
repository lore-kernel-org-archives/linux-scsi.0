From: Adrian Bunk <bunk@stusta.de>
Subject: Re: drivers/scsi/aic7xxx/: How can I edit the _shipped files?
Date: Mon, 15 Nov 2004 19:51:12 +0100
Message-ID: <20041115185111.GD2730@stusta.de>
References: <20041113161400.GA2249@stusta.de> <4198DCD9.5040907@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:13323 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261664AbUKOTAh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 14:00:37 -0500
Content-Disposition: inline
In-Reply-To: <4198DCD9.5040907@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Nov 15, 2004 at 11:44:09AM -0500, Luben Tuikov wrote:
> Adrian Bunk wrote:
> > How can I edit the _shipped files under drivers/scsi/aic7xxx/?
> >
> > The source files they claim to be built from aren't shipped with the
> > kernel.
> >
> 
> Hi Adrian,

Hi Luben,

> Do you mind sharing why you need to change the _shipped files?

they contain unused global code.

> This is how I've changed them in the past: Make the changes in the
> generator files (i.e. the ones the _shipped file(s) depends on),
> build them and then rename them to _shipped.

I've already noticed this after sending my mail.

Anyway, thanks for your help.

> 	Luben

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

