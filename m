From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH RESEND v4 0/5] Migrate SCSI drivers to use dev_pm_ops
Date: Fri, 16 Nov 2012 16:43:04 +0800
Message-ID: <50A5FC98.7050404@intel.com>
References: <1352446075-1814-1-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11526 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab2KPInG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Nov 2012 03:43:06 -0500
In-Reply-To: <1352446075-1814-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

Hi James,

Care to comment?

Thanks,
Aaron

On 11/09/2012 03:27 PM, Aaron Lu wrote:
> This patchset has been quiet for a while, so resend them.
> 
> v4:
> Only Patch 4 is modified:
> Fixed a line over 80 characters warning by checkpatch.pl;
> Update the changelog so that it is no more a try :-)
> 
> v3:
> Only patch 4 is modified:
> Remove the special case for system freeze in scsi_bus_suspend_common
> as pointed out by Alan Stern;
> Updated some comments;
> Removed the use of typedef (*pm_callback_t)(struct device *).
> 
> v2:
> Change the runtime suspend behaviour of sd driver by putting the device
> into stopped power state.
> Revert 2 patches which are no longer needed as pointed out by Alan Stern.
> Find out device callbacks in bus callbacks as suggested by Alan Stern.
> 
> Due to these changes, patch number grows from 2 -> 5.
> 
> v1:
> The 2 patches will migrate SCSI drivers to use the pm callbacks defined
> in dev_pm_ops as pm_message is deprecated and should not be used by driver.
> Bus level callback is changed to use callbacks defined in dev_pm_ops when
> needed and sd's pm callback is updated to use what are defined in dev_pm_ops.
> 
> 
> Aaron Lu (5):
>   sd: put to stopped power state when runtime suspend
>   Revert "[SCSI] scsi_pm: set device runtime state before parent
>     suspended"
>   Revert "[SCSI] runtime resume parent for child's system-resume"
>   pm: use callbacks from dev_pm_ops for scsi devices
>   sd: update sd to use the new pm callbacks
> 
>  drivers/scsi/scsi_pm.c | 98 +++++++++++++++++++++++++++-----------------------
>  drivers/scsi/sd.c      | 18 +++++++---
>  2 files changed, 67 insertions(+), 49 deletions(-)
> 

