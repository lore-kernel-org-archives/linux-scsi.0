From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Wed, 18 Feb 2009 15:12:57 -0500
Message-ID: <499C6BC9.6010706@garzik.org>
References: <499B46B2.5040601@kernel.org>	 <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm>	 <499B6BF7.9090300@kernel.org>	 <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm>	 <499B724A.2040408@kernel.org>	 <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm>	 <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm>	 <499B774C.5010705@kernel.org>	 <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm>	 <499B9129.50104@kernel.org> <20090218122137.GJ16841@parisc-linux.org>	 <alpine.DEB.1.10.0902180426420.25606@asgard.lang.hm>	 <20090218100448.7f7c5b86.akpm@linux-foundation.org>	 <1234982285.3225.42.camel@localhost.localdomain>	 <499C5CAD.1070404@kernel.org> <1234984495.3225.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1234984495.3225.48.camel@localhost.localdomain>
Sender: linux-pci-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, david@lang.hm, Matthew Wilcox <matthew@wil.cx>, Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> Like I said, I'm happy to have MSI completely disabled until LSI wants
> to comment, so no ... only the PCI quirk fix.  The true fix is to have
> the drivers participate in dynamic testing of MSI IRQ routing, but I've
> somewhat lost sight of that.

That's not really a fix at all, just additional, unneeded overhead for 
99% of users.  We don't need our drivers bloated with self-check code 
for all the components in our various computer chips...

	Jeff
