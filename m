From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI
 controllers.
Date: Tue, 26 Jun 2007 08:24:42 -0700
Message-ID: <20070626082442.50ae810e.kristen.c.accardi@intel.com>
References: <20070611184146.448266229@intel.com>
	<20070620142342.404856fe.kristen.c.accardi@intel.com>
	<20070621130831.GN18863@kernel.dk>
	<20070622101509.16d0e93d.kristen.c.accardi@intel.com>
	<20070622190000.GK30033@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070622190000.GK30033@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com, arjan@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 22 Jun 2007 21:00:00 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> Exactly, it needs to be handled by some power management daemon anyway
> and be integrated with power savings in general. You could use io load
> to determine when to enable/disable alpm, for instance.
> 
> > Acked-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> 
> Will you integrate it into the next posting?

yes, I will do that.


Kristen
