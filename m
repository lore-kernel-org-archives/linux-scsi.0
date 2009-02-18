From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Wed, 18 Feb 2009 11:08:29 -0800
Message-ID: <499C5CAD.1070404@kernel.org>
References: <499B46B2.5040601@kernel.org>	 <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm>	 <499B6BF7.9090300@kernel.org>	 <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm>	 <499B724A.2040408@kernel.org>	 <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm>	 <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm>	 <499B774C.5010705@kernel.org>	 <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm>	 <499B9129.50104@kernel.org> <20090218122137.GJ16841@parisc-linux.org>	 <alpine.DEB.1.10.0902180426420.25606@asgard.lang.hm>	 <20090218100448.7f7c5b86.akpm@linux-foundation.org> <1234982285.3225.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1234982285.3225.42.camel@localhost.localdomain>
Sender: linux-pci-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@lang.hm, Matthew Wilcox <matthew@wil.cx>, Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2009-02-18 at 10:04 -0800, Andrew Morton wrote:
> 
>> Do we not need mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch as
>> well, to fix this regression?
> 
> No ... it's a separate issue.  MSI was enabled for fusion SAS in 2.6.26;
> the problem msi patch which the above corrects actually has the effect
> of disabling MSI for fusion and went into 2.6.29-rc2, which isn't a
> kernel that's been tested here.
> 

so for 2.6.26, 27, 28 need pci-enable-msi-on-8132.patch
2.6.29 need pci-enable-msi-on-8132.patch and mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch

YH
