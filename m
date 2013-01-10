From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v12 6/9] libata: expose pm qos flags for ata device
Date: Thu, 10 Jan 2013 11:55:25 -0800
Message-ID: <20130110195525.GK20454@htj.dyndns.org>
References: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
 <1357809870-18816-7-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34485 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab3AJTzb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2013 14:55:31 -0500
Content-Disposition: inline
In-Reply-To: <1357809870-18816-7-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

On Thu, Jan 10, 2013 at 05:24:27PM +0800, Aaron Lu wrote:
> Expose pm qos flags to user space so that user has a chance to disable
> ZPODD feature, if he/she has a broken platform or devices or simply does
> not like this feature.
> 
> This flag is exposed to user space only for ZPODD devices.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
