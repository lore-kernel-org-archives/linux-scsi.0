From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 2/9] libata: Add CONFIG_SATA_ZPODD
Date: Mon, 7 Jan 2013 10:06:43 -0800
Message-ID: <20130107180643.GO3926@htj.dyndns.org>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
 <1357440509-28108-3-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1357440509-28108-3-git-send-email-aaron.lu@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jan 06, 2013 at 10:48:22AM +0800, Aaron Lu wrote:
> Added a new config CONFIG_SATA_ZPODD, which is used to support
> SATA based zero power ODD(ZPODD), and depends on ATA_ACPI.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Maybe just fold this into the next patch?  It's rather unconventional
to introduce the config option and makefile changes by themselves.

Thanks.

-- 
tejun
