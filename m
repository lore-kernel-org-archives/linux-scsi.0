From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 0/7] acpi/libata: Express dependencies for devices on
 dock stations and bays
Date: Wed, 18 Jan 2012 00:40:41 -0500
Message-ID: <4F165B59.8050609@kernel.org>
References: <20111206163718.GA3629@homac.suse.de> <20120105103651.GB13066@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20120105103651.GB13066@homac.suse.de>
Sender: linux-acpi-owner@vger.kernel.org
To: Holger Macht <holger@homac.de>, Jeff Garzik <jgarzik@redhat.com>
Cc: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>, Shaohua Li <shaohua.li@intel.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/05/2012 05:36 AM, Holger Macht wrote:

> On Di 06. Dez - 17:37:19, Holger Macht wrote:
>> Patches 1 through 5 are just a refresh of the patches from Matthew
>> Garrett sent to this list in September 2010 [1]:
>>
>>  [PATCH 1/7] scsi: Export scsi_bus_type
>>  [PATCH 2/7] libata: Bind the Linux device tree to the ACPI device tree
>>  [PATCH 3/7] libata: Migrate ACPI code over to new bindings
>>  [PATCH 4/7] acpi: Add support for linking docks to the objects they contain
>>  [PATCH 5/7] libata: Add links between removable devices and docks
>>
>> Patches 6 and 7 make the patches actually work on my test hardware
>> (Thinkpad x60/Thingpad T60) by fixing some minor issues.
>>
>>  [PATCH 6/7] libata: Generate and pass correct acpi handles
>>  [PATCH 7/7] acpi: Prevent duplicate hotplug device registration on dock stations
> 
> So, due to the merge window for 3.3 being open, I like to give this
> patch set a heads up.
> 
> Matthew, any word on this?
> 
> Len, I really would like to see this merged because it would really make
> the docking station stuff kind of feature complete, finally.

Nice to see this effort.  I hadn't noticed it before.
This is mostly an ATA patch, and so I would hope to see
Tejun review it and Jeff Garzik ship it in his ata tree.

I don't see any problem w/ the ACPI bits.

thanks,
-Len



 drivers/acpi/dock.c         |   98 +++++++++++++++
 drivers/acpi/glue.c         |    2 +
 drivers/ata/libata-acpi.c   |  274 +++++++++++++++++++++++++-----------------
 drivers/ata/libata-core.c   |    6 +-
 drivers/ata/libata-pmp.c    |    4 -
 drivers/ata/libata-scsi.c   |    3 +
 drivers/ata/libata.h        |   13 ++-
 drivers/ata/pata_acpi.c     |    4 +-
 drivers/scsi/scsi_priv.h    |    1 -
 include/acpi/acpi_drivers.h |   11 ++
 include/linux/libata.h      |    7 +-
 include/scsi/scsi.h         |    2 +
 12 files changed, 294 insertions(+), 131 deletions(-)
