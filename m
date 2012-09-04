From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH v6 5/7] scsi: pm: add may_power_off flag
Date: Tue, 04 Sep 2012 18:01:22 +0200
Message-ID: <1539628.e0bNDi5Td8@linux-lqwf.site>
References: <1346768680-7287-1-git-send-email-aaron.lwe@gmail.com> <1346768680-7287-6-git-send-email-aaron.lwe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1346768680-7287-6-git-send-email-aaron.lwe@gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Tuesday 04 September 2012 22:24:38 Aaron Lu wrote:
> From: Aaron Lu <aaron.lu@intel.com>
> 
> Add a new flag may_power_off for scsi device, it gives the user a chance
> to control when the device is runtime suspended, can we remove its power
> if possible.
> 
> And if the device can be powered off(reflected by can_power_off flag,
> determined by individual driver), create a sysfs entry named
> may_power_off to let user control the flag.

Do we really need yet another interface to user space?

	Regards
		Oliver

