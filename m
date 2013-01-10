From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v12 8/9] libata: do not suspend port if normal ODD is
 attached
Date: Thu, 10 Jan 2013 11:57:55 -0800
Message-ID: <20130110195755.GM20454@htj.dyndns.org>
References: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
 <1357809870-18816-9-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1357809870-18816-9-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 10, 2013 at 05:24:29PM +0800, Aaron Lu wrote:
> For ODDs, the upper layer will poll for media change every few
> seconds, which will make it enter and leave suspend state very
> often. And as each suspend will also cause a hard/soft reset,
> the gain of runtime suspend is very little while the ODD may
> malfunction after constantly being reset. So the idle callback
> here will not proceed to suspend if a non-ZPODD capable ODD is
> attached to the port.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
