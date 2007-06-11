From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 2/3] Expose Power Management Policy option to users
Date: Mon, 11 Jun 2007 16:00:29 -0400
Message-ID: <466DA9DD.8080004@garzik.org>
References: <20070611184146.448266229@intel.com> <20070611114820.5290a903.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070611114820.5290a903.kristen.c.accardi@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com
List-Id: linux-scsi@vger.kernel.org

Kristen Carlson Accardi wrote:
> This patch will modify the scsi and ata subsystem to allow
> users to set a power management policy for the link.
> libata drivers can define a function (enable_pm) that will
> perform hardware specific actions to enable whatever power
> management policy the user sets up if the driver supports
> it.  This power management policy will be activated after
> all disks have been enumerated and intialized.
> 
> The scsi subsystem will create a new sysfs file for each
> host in /sys/class/scsi_host called "link_power_management_policy".
> This file can have 3 possible values:
> 
> Value		Meaning
> -------------------------------------------------------------------
> min_power	User wishes the link to conserve power as much as
> 		possible, even at the cost of some performance
> 
> max_performance User wants priority to be on performance, not power
> 		savings
> 
> medium_power	User wants power savings, with less performance cost
> 		than min_power (but less power savings as well).
> 
> 
> Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

seems OK at first glance, though I request that ata and scsi portions be 
split into separate patches

