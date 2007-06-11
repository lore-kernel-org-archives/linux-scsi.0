From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI
 controllers.
Date: Mon, 11 Jun 2007 16:01:13 -0400
Message-ID: <466DAA09.7090000@garzik.org>
References: <20070611184146.448266229@intel.com> <20070611114839.907bcae2.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070611114839.907bcae2.kristen.c.accardi@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com, arjan@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

Kristen Carlson Accardi wrote:
> This patch will set the correct bits to turn on Aggressive
> Link Power Management (ALPM) for the ahci driver.  This
> will cause the controller and disk to negotiate a lower
> power state for the link when there is no activity (see
> the AHCI 1.x spec for details).  This feature is mutually
> exclusive with Hot Plug, so when ALPM is enabled, Hot Plug
> is disabled.  ALPM will be enabled by default, but it is
> settable via the scsi host syfs interface.  Possible 
> settings for this feature are:
> 
> Setting		Effect
> ----------------------------------------------------------
> min_power	ALPM is enabled, and link set to enter 
> 		lowest power state (SLUMBER) when idle
> 		Hot plug not allowed.
> 
> max_performance	ALPM is disabled, Hot Plug is allowed
> 
> medium_power	ALPM is enabled, and link set to enter
> 		second lowest power state (PARTIAL) when
> 		idle.  Hot plug not allowed.
> 
> Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

seems OK at first glance, though I'll have questions about hardware 
behavior once I get off this day-long Intel conference call :)


