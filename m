From: Adrian Bunk <bunk@fs.tum.de>
Subject: Re: [2.6 patch] fix aic7xxx_old.c for !PCI
Date: Thu, 13 May 2004 14:36:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040513123617.GB22202@fs.tum.de>
References: <20040512235555.GF21408@fs.tum.de> <1084434113.2781.6.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:37883 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S264176AbUEMMgY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 08:36:24 -0400
Content-Disposition: inline
In-Reply-To: <1084434113.2781.6.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>, greg@kroah.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, May 13, 2004 at 09:41:53AM +0200, Arjan van de Ven wrote:
> On Thu, 2004-05-13 at 01:55, Adrian Bunk wrote:
> > I got the following compile error in 2.6.6-mm1 (but it's not specific to 
> > -mm) with CONFIG_PCI=n:
> 
> or how about just providing a dummy pci_release_regions() for the !PCI
> case ?

There's no dummy pci_request_regions(), and it might be hard to find a 
return value for a dummy pci_request_regions() that covers all cases.

I'm not religious about this issue, but a dummy pci_release_regions() 
without a dummy pci_request_regions() is a bit asymmetric.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

