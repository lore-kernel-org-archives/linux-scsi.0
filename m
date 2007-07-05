From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 0/4] SATA power savings patches (ALPM)
Date: Thu, 5 Jul 2007 13:03:57 -0700
Message-ID: <20070705130357.1c172b80.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@steeleye.com, edwintorok@gmail.com, axboe@kernel.dk, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Jeff,
Here's the most recent patches for ALPM.  These are also located at:
http://www.kernel.org/pub/linux/kernel/people/kristen/patches/SATA/alpm

These patches implement Aggressive Link Power management for AHCI 
controllers.  This feature is described in detail in the AHCI 1.x spec.
It provides power savings of anywhere from .5-1.5 Watts depending on
the system when it is enabled.  (a graph demonstrating power savings
of this patch along with other power patches is located at 
http://www.linuxpowertop.org/results.php for your enjoyment).

This patch is changed from the previous version in that it incorporates all
the feedback I've gotten on the patches to date.  It changes the default
of the ahci driver to be max_performance rather than min_power, so userspace
will need to explicitly enable alpm via the sysfs interface when it deems
it an appropriate time to do this.  In addition, the patch was changed to
allow either HIPM or DIPM as a prerequisite for enabling ALPM, rather than 
just using HIPM.

Thanks,
Kristen
-- 
