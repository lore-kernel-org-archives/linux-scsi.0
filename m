From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v12 5/9] libata: handle power transition of ODD
Date: Thu, 10 Jan 2013 11:54:07 -0800
Message-ID: <20130110195407.GJ20454@htj.dyndns.org>
References: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
 <1357809870-18816-6-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1357809870-18816-6-git-send-email-aaron.lu@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 10, 2013 at 05:24:26PM +0800, Aaron Lu wrote:
> When ata port is runtime suspended, it will check if the ODD attched to
> it is a zero power(ZP) capable ODD and if the ZP capable ODD is in zero
> power ready state. And if this is not the case, the highest acpi state
> will be limited to ACPI_STATE_D3_HOT to avoid powering off the ODD. And
> if the ODD can be powered off, runtime wake capability needs to be
> enabled and powered_off flag will be set to let resume code knows that
> the ODD was in powered off state.
> 
> And on resume, before it is powered on, if it was powered off during
> suspend, runtime wake capability needs to be disabled. After it is
> recovered, the ODD is considered functional, post power on processing
> like eject tray if the ODD is drawer type is done, and several ZPODD
> related fields will also be reset.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
