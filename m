From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 0/4] ata port runtime power management support
Date: Thu, 10 Nov 2011 07:37:07 -0800
Message-ID: <20111110153707.GE27258@google.com>
References: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
 <Pine.LNX.4.44L0.1111101028250.2338-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1111101028250.2338-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 10, 2011 at 10:30:53AM -0500, Alan Stern wrote:
> Currently, disks will not be runtime-suspended unless (1) the user 
> requests it by setting the appropriate power/control attribute, and (2) 
> the device file is closed (in particular, the disk has no mounted 
> filesystems or swap partitions).  I don't imagine this combination of 
> events is very common for disks using libata.

Empty ports are pretty common and pm should be able to put the
unoccupied ports and the containing pci device into sleep state which
can save some power.  Would be nice to have some numbers tho.  But
either way, if this doesn't break anything, I don't see any reason to
object to it - the hierarchy reorg is more of logical cleanup and
runtime pm is trivial afterwards.

Thanks.

-- 
tejun
