From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v12 3/9] libata: move acpi notification code to zpodd
Date: Thu, 10 Jan 2013 11:48:19 -0800
Message-ID: <20130110194819.GH20454@htj.dyndns.org>
References: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
 <1357809870-18816-4-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1357809870-18816-4-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 10, 2013 at 05:24:24PM +0800, Aaron Lu wrote:
> Since the ata acpi notification code introduced in commit
> 3bd46600a7a7e938c54df8cdbac9910668c7dfb0 is solely for ZPODD, and we
> now have a dedicated place for it, move these code there.
> 
> And the ata_acpi_add_pm_notifier code is changed a little bit in that it
> is now invoked when scsi device is not bound with ACPI yet, so the way
> to get the acpi handle is different with the previous version. And the
> ata_acpi_add/remove_pm_notifier is also simplified a little bit in that
> it doesn't check if the acpi_device for the handle exists or not as the
> odd_can_poweroff function already checked that.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
