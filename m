From: Holger Macht <holger@homac.de>
Subject: Re: [PATCH 0/7] acpi/libata: Express dependencies for devices on
 dock stations and bays
Date: Thu, 5 Jan 2012 11:36:52 +0100
Message-ID: <20120105103651.GB13066@homac.suse.de>
References: <20111206163718.GA3629@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111206163718.GA3629@homac.suse.de>
Sender: linux-acpi-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>, Shaohua Li <shaohua.li@intel.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Di 06. Dez - 17:37:19, Holger Macht wrote:
> Patches 1 through 5 are just a refresh of the patches from Matthew
> Garrett sent to this list in September 2010 [1]:
> 
>  [PATCH 1/7] scsi: Export scsi_bus_type
>  [PATCH 2/7] libata: Bind the Linux device tree to the ACPI device tree
>  [PATCH 3/7] libata: Migrate ACPI code over to new bindings
>  [PATCH 4/7] acpi: Add support for linking docks to the objects they contain
>  [PATCH 5/7] libata: Add links between removable devices and docks
> 
> Patches 6 and 7 make the patches actually work on my test hardware
> (Thinkpad x60/Thingpad T60) by fixing some minor issues.
> 
>  [PATCH 6/7] libata: Generate and pass correct acpi handles
>  [PATCH 7/7] acpi: Prevent duplicate hotplug device registration on dock stations

So, due to the merge window for 3.3 being open, I like to give this
patch set a heads up.

Matthew, any word on this?

Len, I really would like to see this merged because it would really make
the docking station stuff kind of feature complete, finally.

Thanks,
 Holger
