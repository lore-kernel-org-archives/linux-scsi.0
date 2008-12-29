From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH -next v2] cxgb3i: use same dependencies & selects as
	CHELSIO_T3
Date: Mon, 29 Dec 2008 15:58:07 -0600
Message-ID: <1230587887.3302.70.camel@localhost.localdomain>
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>
	 <20081229130110.67d5271a.randy.dunlap@oracle.com>
	 <20081229132312.10934479.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20081229132312.10934479.randy.dunlap@oracle.com>
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, kxie@chelsio.com, akpm <akpm@linux-foundation.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-12-29 at 13:23 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Make the CXGB iSCSI driver (that selects the CXGB net driver) have the same
> dependencies as the net driver, since kconfig doesn't do that automatically.
> Also make it select INET_LRO & FW_LOADER like the net driver does.

I thought select of a symbol that selected something else propagated
correctly (even if select of a symbol that depends on something else
doesn't).   If this is untrue, we have several other Kconfig problems in
the kernel.

James
