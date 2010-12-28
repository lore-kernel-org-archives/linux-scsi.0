From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for December 28 (drivers/target/)
Date: Tue, 28 Dec 2010 08:50:16 -0800
Message-ID: <20101228085016.dedc8b18.randy.dunlap@oracle.com>
References: <20101228173049.217c192d.sfr@canb.auug.org.au>
	<20101228082947.70b09534.randy.dunlap@oracle.com>
	<1293554355.2371.1.camel@fuzzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1293554355.2371.1.camel@fuzzy>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, nab@kernel.org, scsi <linux-scsi@vger.kernel.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 28 Dec 2010 10:39:14 -0600 James Bottomley wrote:

> On Tue, 2010-12-28 at 08:29 -0800, Randy Dunlap wrote:
> > On Tue, 28 Dec 2010 17:30:49 +1100 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > [The mirroring on kernel.org is running slowly]
> > > 
> > > Changes since 20101227:
> > 
> > 
> > warning: (TARGET_CORE && GFS2_FS) selects CONFIGFS_FS which has unmet direct dependencies (SYSFS)
> > 
> > from:
> > 
> > menuconfig TARGET_CORE
> > 	tristate "Generic Target Core Mod (TCM) and ConfigFS Infrastructure"
> > 	select CONFIGFS_FS
> > 
> > but CONFIGFS_FS depends on SYSFS, so TARGET_CORE should either depend on SYSFS
> > or (eek) it should select SYSFS.
> 
> The latter, I think (and actually, configfs should select sysfs).  All
> these unmet dependencies are a minefield.

It's just another language to deal with.  Not a big deal, except for the
twists that EXPERIMENTAL injects into it.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
