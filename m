From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 0/9] ZPODD Patches
Date: Mon, 7 Jan 2013 10:49:28 -0800
Message-ID: <20130107184928.GV3926@htj.dyndns.org>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Aaron.

On Sun, Jan 06, 2013 at 10:48:20AM +0800, Aaron Lu wrote:
> v11:
> Introduce event_driven flag in scsi_device to silence the media event
> poll after ODD is powered off;
> Removed ata layer PM QOS control, instead, simply limit ACPI state to
> D3_HOT when choosing state;
> Make the power off delay a module param named zpodd_poweroff_delay,
> defaults to 30 seconds.

Other than the nitpicks.  The series generally looks good to me.

Thanks a lot!

-- 
tejun
