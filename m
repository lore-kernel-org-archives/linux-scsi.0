From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 07/10] block: add a new interface to block events
Date: Mon, 12 Nov 2012 11:14:40 -0800
Message-ID: <20121112191440.GF5560@mtj.dyndns.org>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
 <1352443922-13734-8-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1352443922-13734-8-git-send-email-aaron.lu@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 09, 2012 at 02:51:59PM +0800, Aaron Lu wrote:
> A new interface to block disk events is added, this interface is
> meant to eliminate a race between PM runtime callback and disk events
> checking.
> 
> Suppose the following device tree:
> device_sata_port  (the parent)
>   device_ODD      (the child)

Weren't you gonna do something different about this?  I mean, if sr
knows that autopm kicked in, it can simply tell the block layer that
nothing is going on.  Wouldn't that be simpler?

Thanks.

-- 
tejun
