From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v13 2/9] libata: identify and init ZPODD devices
Date: Mon, 21 Jan 2013 17:28:07 +0800
Message-ID: <50FD0A27.7080404@intel.com>
References: <1358241665-2156-1-git-send-email-aaron.lu@intel.com> <1358241665-2156-3-git-send-email-aaron.lu@intel.com> <50FD0787.90006@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <50FD0787.90006@pobox.com>
Sender: linux-pm-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/21/2013 05:16 PM, Jeff Garzik wrote:
> On 01/15/2013 04:20 AM, Aaron Lu wrote:
>> The ODD can be enabled for ZPODD if the following three conditions are
>> satisfied:
>> 1 The ODD supports device attention;
>> 2 The platform can runtime power off the ODD through ACPI;
>> 3 The ODD is either slot type or drawer type.
>> For such ODDs, zpodd_init is called and a new structure is allocated for
>> it to store ZPODD related stuffs.
>>
>> And the zpodd_dev_enabled function is used to test if ZPODD is currently
>> enabled for this ODD.
>>
>> A new config CONFIG_SATA_ZPODD is added to selectively build ZPODD code.
>>
>> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
>> Acked-by: Tejun Heo <tj@kernel.org>
> 
> How possible is it to apply patches 2-6 right now?  It appears possible 
> according to my read, but I've not tested this guess.

Patches 2-6 and 8 can be applied cleanly on top of today's Linus tree
with or without your NEXT branch merged.

Thanks,
Aaron

