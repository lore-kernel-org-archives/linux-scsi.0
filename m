From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 1/3] Store interrupt value
Date: Mon, 11 Jun 2007 15:59:24 -0400
Message-ID: <466DA99C.4050105@garzik.org>
References: <20070611184146.448266229@intel.com> <20070611114810.f918bc1d.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758069AbXFKT7x@vger.kernel.org>
In-Reply-To: <20070611114810.f918bc1d.kristen.c.accardi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com, arjan@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

Kristen Carlson Accardi wrote:
> Use a stored value for which interrupts to enable.  Changing this allows
> us to selectively turn off certain interrupts later and have them 
> stay off.
> 
> Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Seems OK, though a bit disappointing that this cannot be initial set in
ahci_save_initial_config() [which admittedly only saves per-HBA settings 
at the moment, but due to new init model, need not be limited as such]
