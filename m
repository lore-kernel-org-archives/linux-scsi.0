From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for December 27 (drivers/target)
Date: Mon, 27 Dec 2010 11:57:55 -0800
Message-ID: <20101227115755.ffcdfc4f.randy.dunlap@oracle.com>
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, nab@kernel.org, scsi <linux-scsi@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 27 Dec 2010 17:04:51 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> [The mirroring on kernel.org is running slowly]
> 
> Changes since 20101221:
> 
> Linus' tree lost its build failure.


Hi Nick,

Please test building target code when CONFIG_BLOCK is not enabled.

When CONFIG_BLOCK is not enabled, drivers/target/ gets a boat load of build errors.

Should TCM_IBLOCK depend on BLOCK?  That fixes lots of the build errors,
but not all of them.


The header file include/target/target_core_base.h uses struct queue_limits,
so it should #include <linux/blkdev.h>.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
