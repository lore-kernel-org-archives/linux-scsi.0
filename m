From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v9 04/10] libata: acpi: move acpi notification code to
 zpodd
Date: Wed, 14 Nov 2012 09:36:29 +0800
Message-ID: <50A2F59D.9070309@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com> <1352443922-13734-5-git-send-email-aaron.lu@intel.com> <20121112185544.GC5560@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20121112185544.GC5560@mtj.dyndns.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/13/2012 02:55 AM, Tejun Heo wrote:
> On Fri, Nov 09, 2012 at 02:51:56PM +0800, Aaron Lu wrote:
>> Since the ata acpi notification code introduced in commit
>> 3bd46600a7a7e938c54df8cdbac9910668c7dfb0 is solely for ZPODD, and we
>> now have a dedicated place for it, move these code there.
>>
>> And the add/remove_pm_notifier code is simplified a little bit that it
>> does not check things like if the handle is NULL and if a corresponding
>> acpi_device is there for the handle as they are guaranteed by the
>> device_can_poweroff already.
> 
> Please don't mix code movement with actual changes.  It makes it
> difficult to track what's going on.

Oh, yes.
But since add_pm_notifier code happens during ZPODD init time, and init
now happens during first time probe instead of after SCSI device has
been created, some changes are necessary when moving these code.

Sorry for not describing these things clear, I'll update the changelog
to reflect this next time.

Thanks,
Aaron

