From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] Add proper module ID tables to Adaptec aic7[9x]xx drivers
Date: Mon, 21 Jun 2004 11:30:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40D6FEFC.9050005@adaptec.com>
References: <20040621161441.20dfcee6.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:21154 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S266263AbUFUPaI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 11:30:08 -0400
In-Reply-To: <20040621161441.20dfcee6.ak@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: linux-scsi@vger.kernel.org

Thank you Andi for the patches. aic7xxx drivers are due for update
to use the new timeout infrastructure. I'll incorporate them in,
and do some testing.

Thanks,
-- 
Luben

Andi Kleen wrote:
> 
> [I didn't find an aic7xxx maintainer in MAINTAINERS, so just sending
> to the list]
> 
> This is needed for 2.6 hotplug where the driver is autoloaded. When you 
> have
> multiple conflicting entries the hotplug module loader usually loads
> the first one listed, which may be correct or may be not.
> 
> With these changes the drivers announce the correct PCI IDs.
> 
> The patches are quite big (i had to move the ID tables into an include),
> but mostly mechanical.
> 
> I only tested it on a single 78xx, so it's possible that i made
> a typo somewhere. Some testing would be appreciated, especially
> on 79xx
> 
> There is still an conflicting entry for aic7xxx_old unfortunately. This
> is hard to handle in hotplug. I think the right solution would be to 
> somehow
> tag drivers as obsolete so that they aren't loaded by default. This will
> need an extension in the module pci table mechanism. I'm thinking about
> a a new MODULE_OBSOLETE macro for this and a obsolete_modules table 
> generated
> at modules_install time. But that's for another patch. Better would be
> maybe to just drop the aic7xxx_old driver. Is it really still needed?
> 
> -Andi



