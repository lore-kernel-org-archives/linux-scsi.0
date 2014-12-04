From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/12] nobody loves the advansys driver
Date: Thu, 4 Dec 2014 10:12:07 +0100
Message-ID: <20141204091207.GA23891@lst.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de> <20141203152141.GA6175@lst.de> <201412031634.48711.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57346 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102AbaLDJMJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 04:12:09 -0500
Content-Disposition: inline
In-Reply-To: <201412031634.48711.linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On Wed, Dec 03, 2014 at 04:34:48PM +0100, Ondrej Zary wrote:
> I have an ASB-3940UA (bought around 2000) and use it for scanner so I can test 
> patches.
> The driver was working fine so I never had to look at the code. Now I see that 
> it's 12K lines long :( Converting that to something simple would require a 
> lot of work.

So we've got a dedicated tester for the narrow boards :)

Just by splitting that monster in the two drivers it's underneath and
removing various pointless wrappers they'd be down to a fairly reasonable
size.
