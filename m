From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCHv2 0/7] acpi/libata: Express dependencies for devices on
 dock stations and bays
Date: Tue, 27 Mar 2012 16:11:52 +0800
Message-ID: <CAF1ivSY52ESfF02QywCFdf68_hSkOMg1R=0KwojeGJx2ALWCYg@mail.gmail.com>
References: <20120120001817.GA27706@homac.suse.de>
	<CAF1ivSYhOTitPctsJOTKWN9HDt0VZpQe_-_a0LnLefVGxOJtXg@mail.gmail.com>
	<20120209073345.GA11121@homac.suse.de>
	<4F33E615.6070607@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <4F33E615.6070607@garzik.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Holger Macht <holger@homac.de>, linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 9, 2012 at 11:28 PM, Jeff Garzik <jeff@garzik.org> wrote:
> On 02/09/2012 02:33 AM, Holger Macht wrote:
>>
>> On Do 09. Feb - 14:46:11, Lin Ming wrote:
>>>
>>> On Fri, Jan 20, 2012 at 8:18 AM, Holger Macht<holger@homac.de> =A0w=
rote:
>>>>
>>>> Patches 2 through 5 are just a refresh of the patches from Matthew
>>>> Garrett sent to this list in September 2010 [1]:
>>>>
>>>> Patch 1 is a new patch incorporating the corrections from James
>>>> Bottomley. Patch 6, 7 and 8 make the whole patch set actually work=
 on my
>>>> test hardware (Thinkpad x60/Thinkpad T60) by fixing minor issues a=
nd
>>>> compensating changes after the first submission.
>>>>
>>>> All patches now contain the correct Signed-off-by instead of Acked=
-by
>>>> tags.
>>>>
>>>> =A0[PATCH 1/8] scsi: Add wrapper to access and set scsi_bus_type i=
n struct
>>>> acpi_bus_type
>>>> =A0[PATCH 2/8] libata: Bind the Linux device tree to the ACPI devi=
ce tree
>>>> =A0[PATCH 3/8] libata: Migrate ACPI code over to new bindings
>>>> =A0[PATCH 4/8] acpi: Add support for linking docks to the objects =
they
>>>> contain
>>>> =A0[PATCH 5/8] libata: Add links between removable devices and doc=
ks
>>>> =A0[PATCH 6/8] libata: Generate and pass correct acpi handles
>>>> =A0[PATCH 7/8] acpi: Prevent duplicate hotplug device registration=
 on dock
>>>> stations
>>>> =A0[PATCH 8/8] libata: Use correct PCI devices
>>>
>>>
>>> Hi Holger,
>>>
>>> What's the status of these patches?
>>
>>
>> They've been ACKed by both ACPI (Len Brown) and libata (James Bottom=
ley)
>> people, so I guess they are good to go and I'm waiting for someone (=
Jeff
>> Garzik?) to pick them up.
>
>
> I ACK'd for libata. =A0It's queued in libata-dev... =A0but looks like=
 that did
> not get pushed out. =A0Should show up in the next linux-next.
>
> =A0 =A0 =A0 =A0Jeff

Hi,

I didn't find these patches in libata-dev tree.
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

Are they removed for some reason?

Regards,
Lin Ming
--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
