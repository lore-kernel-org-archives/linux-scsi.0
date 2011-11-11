From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v2 0/4] ata port runtime power management support
Date: Fri, 11 Nov 2011 10:25:56 +0800
Message-ID: <1320978356.32515.11.camel@minggr>
References: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
	 <20111110153036.GC27258@google.com>  <20111110153132.GD27258@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111110153132.GD27258@google.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-11-10 at 23:31 +0800, Tejun Heo wrote:
> Ooh, by the way, can you please write more about how you tested it?

I have 2 disks installed.
sda installs the OS. I use sdb to test ata port runtime PM.

# set "auto" to enable disk runtime PM
# echo auto > /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/2:0:0:0/power/control

mount sdb1 causes ata port resume

umount sdb1 causes ata port suspend

> 
> Thanks.
> 


