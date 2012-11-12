From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 04/10] libata: acpi: move acpi notification code to
 zpodd
Date: Mon, 12 Nov 2012 10:55:44 -0800
Message-ID: <20121112185544.GC5560@mtj.dyndns.org>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
 <1352443922-13734-5-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1352443922-13734-5-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 09, 2012 at 02:51:56PM +0800, Aaron Lu wrote:
> Since the ata acpi notification code introduced in commit
> 3bd46600a7a7e938c54df8cdbac9910668c7dfb0 is solely for ZPODD, and we
> now have a dedicated place for it, move these code there.
> 
> And the add/remove_pm_notifier code is simplified a little bit that it
> does not check things like if the handle is NULL and if a corresponding
> acpi_device is there for the handle as they are guaranteed by the
> device_can_poweroff already.

Please don't mix code movement with actual changes.  It makes it
difficult to track what's going on.

Thanks.

-- 
tejun
