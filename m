From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: linux-next: Tree for December 27 (drivers/target/)
Date: Mon, 27 Dec 2010 14:47:41 -0800
Message-ID: <1293490061.4649.205.camel@haakon2.linux-iscsi.org>
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
	 <20101227112114.634c6e60.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20101227112114.634c6e60.randy.dunlap@oracle.com>
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-12-27 at 11:21 -0800, Randy Dunlap wrote:
> On Mon, 27 Dec 2010 17:04:51 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > [The mirroring on kernel.org is running slowly]
> 
> yep :(
> 
> > Changes since 20101221:
> 
> 
> When CONFIG_SCSI is not enabled:
> 
> ERROR: "scsi_device_type" [drivers/target/target_core_mod.ko] undefined!
> 
> from target_core_transport.c::1586:
> 
> 	printk("  Type:   %s ", scsi_device_type(device_type));
> 

Hi Randy and Stephen,

As there is really no a reason for building CONFIG_TARGET_CORE w/o
CONFIG_SCSI && CONFIG_BLOCK, the following patch has been added to the
new linux-next target tree here:

target: Add SCSI and BLOCK depends for TARGET_CORE
http://git.kernel.org/?p=linux/kernel/git/nab/linux-next.git;a=commitdiff;h=15c8da9639029ac337dd2f0bb67010de62d4b724

> 
> Also please update MAINTAINERS for drivers/target/.
> 

Also added here, thanks for the reminder:

target: Add drivers/target/ entry to MAINTAINERS
http://git.kernel.org/?p=linux/kernel/git/nab/linux-next.git;a=commitdiff;h=85356c6c328b3c4add3d240e387087a76a469028

Best Regards,

--nab
