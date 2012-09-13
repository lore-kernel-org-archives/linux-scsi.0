From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/2] scsi: sd: set ready_to_power_off for scsi disk
Date: Thu, 13 Sep 2012 16:23:29 +0800
Message-ID: <50519801.6080502@intel.com>
References: <1347522049-1836-1-git-send-email-aaron.lu@intel.com>  <1347522049-1836-2-git-send-email-aaron.lu@intel.com> <1347524092.2720.1.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1347524092.2720.1.camel@dabdike.int.hansenpartnership.com>
Sender: linux-acpi-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, Oliver Neukum <oliver@neukum.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/13/2012 04:14 PM, James Bottomley wrote:
> On Thu, 2012-09-13 at 15:40 +0800, Aaron Lu wrote:
>> The ready_to_power_off flag is used to give indication to ATA layer
>> if this device's power can be removed when runtime suspended.
>>
>> This flag is determined by individual SCSI driver like sr, sd.
>>
>> This flag is introduced to support zero power ODD. When ODD
>> is runtime suspended, it may not be OK to remove its power.
>>
>> But for disk, it is always OK to be powered off, so set this flag.
> 
> It is? I may have missed this, but where do you flush the cache of write
> back cache devices you're about to power off?

I suppose that is handled in sd_suspend callback, the power off happens
after a device is runtime suspended.

Thanks,
Aaron
