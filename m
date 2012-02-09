From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCHv2 0/7] acpi/libata: Express dependencies for devices on
 dock stations and bays
Date: Thu, 09 Feb 2012 10:28:21 -0500
Message-ID: <4F33E615.6070607@garzik.org>
References: <20120120001817.GA27706@homac.suse.de> <CAF1ivSYhOTitPctsJOTKWN9HDt0VZpQe_-_a0LnLefVGxOJtXg@mail.gmail.com> <20120209073345.GA11121@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20120209073345.GA11121@homac.suse.de>
Sender: linux-acpi-owner@vger.kernel.org
To: Holger Macht <holger@homac.de>
Cc: Lin Ming <ming.m.lin@intel.com>, linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 02/09/2012 02:33 AM, Holger Macht wrote:
> On Do 09. Feb - 14:46:11, Lin Ming wrote:
>> On Fri, Jan 20, 2012 at 8:18 AM, Holger Macht<holger@homac.de>  wrote:
>>> Patches 2 through 5 are just a refresh of the patches from Matthew
>>> Garrett sent to this list in September 2010 [1]:
>>>
>>> Patch 1 is a new patch incorporating the corrections from James
>>> Bottomley. Patch 6, 7 and 8 make the whole patch set actually work on my
>>> test hardware (Thinkpad x60/Thinkpad T60) by fixing minor issues and
>>> compensating changes after the first submission.
>>>
>>> All patches now contain the correct Signed-off-by instead of Acked-by
>>> tags.
>>>
>>>   [PATCH 1/8] scsi: Add wrapper to access and set scsi_bus_type in struct acpi_bus_type
>>>   [PATCH 2/8] libata: Bind the Linux device tree to the ACPI device tree
>>>   [PATCH 3/8] libata: Migrate ACPI code over to new bindings
>>>   [PATCH 4/8] acpi: Add support for linking docks to the objects they contain
>>>   [PATCH 5/8] libata: Add links between removable devices and docks
>>>   [PATCH 6/8] libata: Generate and pass correct acpi handles
>>>   [PATCH 7/8] acpi: Prevent duplicate hotplug device registration on dock stations
>>>   [PATCH 8/8] libata: Use correct PCI devices
>>
>> Hi Holger,
>>
>> What's the status of these patches?
>
> They've been ACKed by both ACPI (Len Brown) and libata (James Bottomley)
> people, so I guess they are good to go and I'm waiting for someone (Jeff
> Garzik?) to pick them up.

I ACK'd for libata.  It's queued in libata-dev...  but looks like that 
did not get pushed out.  Should show up in the next linux-next.

	Jeff




