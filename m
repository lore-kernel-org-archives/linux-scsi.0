From: Samuel Colin <Samuel.Colin3@wanadoo.fr>
Subject: Re: Magical ansi scsi revision (was Re: [linux-usb-devel] Re: What
 is SCSI command 0xa0 ?)
Date: Thu, 17 Feb 2005 23:49:53 +0100
Message-ID: <20050217234953.15816a82@hebus>
References: <20050217221803.091fd840@hebus>
	<Pine.LNX.4.44L0.0502171719290.627-100000@ida.rowland.org>
Reply-To: samuel.colin3@wanadoo.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from smtp2.wanadoo.fr ([193.252.22.29]:29077 "EHLO smtp2.wanadoo.fr")
	by vger.kernel.org with ESMTP id S261214AbVBQWtu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 17:49:50 -0500
In-Reply-To: <Pine.LNX.4.44L0.0502171719290.627-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

The Thu, 17 Feb 2005 17:23:54 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> Well, that explains why you had problems starting with 2.6.10!
> 
> The explanation is simple enough, and it can be found in a line from your 
> logs:
> 
> Feb 17 21:19:09 gnondpom kernel: usb-storage: Fixing INQUIRY data to show
> SCSI rev 2 - was 4
> 
> Back in 2.6.8, the usb-storage driver would automatically change the SCSI 
> revision of any device to 2.  In 2.6.10 it doesn't do that if the actual 
> revision is > 2.
> 
Then it explains a lot. I see you have sent a patch for the REPORT_LUNS
problems. On my part all seem to work well so I can not do much more :-).
Here is the product page of the offending disk : 

http://www.lacie.com/products/product.htm?pid=10025

As usb (and firewire) disks will become more popular, I guess the scsi-dev
list should expect more problems of this kind :-(

Anyway, many thanks for your kindness and your reactivity (you and both
lists) :-)

Regards,
Samuel Colin

