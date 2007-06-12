From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 0/3] AHCI Link Power Management
Date: Tue, 12 Jun 2007 10:58:13 +0900
Message-ID: <466DFDB5.9030901@gmail.com>
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070611114600.7fca1c24.kristen.c.accardi@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arjan@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

Kristen Carlson Accardi wrote:
> Hi,
> This series of patches enables Aggressive Link Power Management for AHCI 
> devices, as documented in the AHCI spec.  On my laptop (a Lenovo X60), this
> saves me a full watt of power.  On other systems, reported power savings
> range from .5-1.5 Watts.  It has been tested by the kind folks at #powertop
> with similar results.  Please give it a try and let me know what you think.

I'm not sure about this.  We need better PM framework to support
powersaving in other controllers and some ahcis don't save much when
only link power management is used, they need to be turned off
completely && I don't think scsi sysfs is the right place to export this
interface.

-- 
tejun
