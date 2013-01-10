From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v12 2/9] libata: identify and init ZPODD devices
Date: Thu, 10 Jan 2013 11:47:27 -0800
Message-ID: <20130110194727.GG20454@htj.dyndns.org>
References: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
 <1357809870-18816-3-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:60209 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab3AJTrd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2013 14:47:33 -0500
Content-Disposition: inline
In-Reply-To: <1357809870-18816-3-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

On Thu, Jan 10, 2013 at 05:24:23PM +0800, Aaron Lu wrote:
> The ODD can be enabled for ZPODD if the following three conditions are
> satisfied:
> 1 The ODD supports device attention;
> 2 The platform can runtime power off the ODD through ACPI;
> 3 The ODD is either slot type or drawer type.
> For such ODDs, zpodd_init is called and a new structure is allocated for
> it to store ZPODD related stuffs.
> 
> And the zpodd_dev_enabled function is used to test if ZPODD is currently
> enabled for this ODD.
> 
> A new config CONFIG_SATA_ZPODD is added to selectively build ZPODD code.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
