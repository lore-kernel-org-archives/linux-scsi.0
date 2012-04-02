From: Holger Macht <holger@homac.de>
Subject: Re: [PATCHv2 0/7] acpi/libata: Express dependencies for devices on
 dock stations and bays
Date: Mon, 02 Apr 2012 20:39:39 +0200
Message-ID: <4F79F26B.5070307@homac.de>
References: <20120120001817.GA27706@homac.suse.de> <CAF1ivSYhOTitPctsJOTKWN9HDt0VZpQe_-_a0LnLefVGxOJtXg@mail.gmail.com> <20120209073345.GA11121@homac.suse.de> <4F33E615.6070607@garzik.org> <CAF1ivSY52ESfF02QywCFdf68_hSkOMg1R=0KwojeGJx2ALWCYg@mail.gmail.com> <4F796FD9.2010901@homac.de> <4F79C98B.6020201@garzik.org> <4F79D720.7040607@homac.de> <4F79E477.5050201@garzik.org>
Reply-To: holger@homac.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wp050.webpack.hosteurope.de ([80.237.132.57]:49210 "EHLO
	wp050.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752229Ab2DBSjp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2012 14:39:45 -0400
In-Reply-To: <4F79E477.5050201@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Lin Ming <ming.m.lin@intel.com>, linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@redhat.com>, sfr@canb.auug.org.au

On 02.04.2012 19:40, Jeff Garzik wrote:
> On 04/02/2012 12:43 PM, Holger Macht wrote:
>> On 02.04.2012 17:45, Jeff Garzik wrote:
>>> On 04/02/2012 05:22 AM, Holger Macht wrote:
>>>> On 27.03.2012 10:11, Lin Ming wrote:
>>>>> On Thu, Feb 9, 2012 at 11:28 PM, Jeff Garzik<jeff@garzik.org>  wrote:
>>>>>> On 02/09/2012 02:33 AM, Holger Macht wrote:
>>>>>>>
>>>>>>> On Do 09. Feb - 14:46:11, Lin Ming wrote:
>>>>>>>>
>>>>>>>> On Fri, Jan 20, 2012 at 8:18 AM, Holger Macht<holger@homac.de>
>>>>>>>> wrote:
>>>>>>>>>
>>>>>>>>> Patches 2 through 5 are just a refresh of the patches from Matthew
>>>>>>>>> Garrett sent to this list in September 2010 [1]:
>>>>>>>>>
>>>>>>>>> Patch 1 is a new patch incorporating the corrections from James
>>>>>>>>> Bottomley. Patch 6, 7 and 8 make the whole patch set actually work
>>>>>>>>> on my
>>>>>>>>> test hardware (Thinkpad x60/Thinkpad T60) by fixing minor issues
>>>>>>>>> and
>>>>>>>>> compensating changes after the first submission.
>>>>>>>>>
>>>>>>>>> All patches now contain the correct Signed-off-by instead of
>>>>>>>>> Acked-by
>>>>>>>>> tags.
>>>>>>>>>
>>>>>>>>> [PATCH 1/8] scsi: Add wrapper to access and set scsi_bus_type in
>>>>>>>>> struct
>>>>>>>>> acpi_bus_type
>>>>>>>>> [PATCH 2/8] libata: Bind the Linux device tree to the ACPI device
>>>>>>>>> tree
>>>>>>>>> [PATCH 3/8] libata: Migrate ACPI code over to new bindings
>>>>>>>>> [PATCH 4/8] acpi: Add support for linking docks to the objects they
>>>>>>>>> contain
>>>>>>>>> [PATCH 5/8] libata: Add links between removable devices and docks
>>>>>>>>> [PATCH 6/8] libata: Generate and pass correct acpi handles
>>>>>>>>> [PATCH 7/8] acpi: Prevent duplicate hotplug device registration on
>>>>>>>>> dock
>>>>>>>>> stations
>>>>>>>>> [PATCH 8/8] libata: Use correct PCI devices
>>>>>>>>
>>>>>>>>
>>>>>>>> Hi Holger,
>>>>>>>>
>>>>>>>> What's the status of these patches?
>>>>>>>
>>>>>>>
>>>>>>> They've been ACKed by both ACPI (Len Brown) and libata (James
>>>>>>> Bottomley)
>>>>>>> people, so I guess they are good to go and I'm waiting for someone
>>>>>>> (Jeff
>>>>>>> Garzik?) to pick them up.
>>>>>>
>>>>>>
>>>>>> I ACK'd for libata. It's queued in libata-dev... but looks like
>>>>>> that did
>>>>>> not get pushed out. Should show up in the next linux-next.
>>>>>>
>>>>>> Jeff
>>>>>
>>>>> Hi,
>>>>>
>>>>> I didn't find these patches in libata-dev tree.
>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
>>>>
>>>> They've been there, also in linux-next. But now I'm not able to find a
>>>> trace of them. Maybe the two fixes from the thread labeled "linux-next:
>>>> dock_link_device is oopsy" on linux-kernel@ didn't find their way into
>>>> the trees and so the patches were removed. Just guessing...
>>>>
>>>> Regards,
>>>> Holger
>>>>
>>>>> Are they removed for some reason?
>>>
>>> They were removed because people had problems with them, and the patch
>>> authors did not engage and fix the problem(s). Matthew Garrett spoke up
>>> and said he didn't have time to investigate, so the patches were dropped.
>>
>> Do you have a pointer for the problems?
>
> You were CC'd...

Ok, found them. However, wouldn't have made a difference because the 
solution doesn't seem to be easy. And I currently also don't have the 
time to do massive investigations. What a pity, but maybe a future time...

Thanks,
  Holger



