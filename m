From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: Tree for Aug 30 (scsi/qla4xxx)
Date: Thu, 1 Sep 2011 09:20:14 -0700
Message-ID: <20110901092014.4be19efa.rdunlap@xenotime.net>
References: <20110830171605.168f29decb0558fa31e59210@canb.auug.org.au>
	<20110831134515.049f584b.rdunlap@xenotime.net>
	<4E5EF3B4.90204@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <4E5EF3B4.90204@cs.wisc.edu>
Sender: linux-next-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, iscsi-driver@qlogic.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 31 Aug 2011 21:53:40 -0500 Mike Christie wrote:

> On 08/31/2011 03:45 PM, Randy Dunlap wrote:
> > On Tue, 30 Aug 2011 17:16:05 +1000 Stephen Rothwell wrote:
> > 
> >> Hi all,
> > 
> > [Sorry about the delay.. slow build machine.
> > Please ignore if this is already known/fixed.]
> > 
> > 
> > (on i386)
> > 
> > ERROR: "iscsi_boot_create_target" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> > ERROR: "iscsi_boot_create_ethernet" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> > ERROR: "iscsi_boot_create_host_kset" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> > ERROR: "iscsi_boot_create_initiator" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> > ERROR: "iscsi_boot_destroy_kset" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> > 
> > when CONFIG_ISCSI_BOOT_SYSFS is not enabled.
> > 
> 
> 
> We need the attached patch.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
