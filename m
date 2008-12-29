From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for December 29 (fcoe)
Date: Mon, 29 Dec 2008 12:31:15 -0800
Message-ID: <20081229123115.9a255fa8.randy.dunlap@oracle.com>
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20081230031621.60acd90b.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 30 Dec 2008 03:16:21 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20081219:
> 
> Undropped tree:
> 	scci
> 	mtd
> 
> Dropped trees (temporarily):
> 	nfs (akpm request due to 2.6.30 features)
> 	kvm (build problem)
> 	rr (build poblem)
> 	semaphore-removal (due to unfixed conflicts against Linus' tree)
> 	cpu_alloc (build problem)
> 	audit (difficult conflicts)
> 
> Linus' tree had three build failures requiring patches and one requiring
> a revert.


linux-next-20081229/drivers/scsi/fcoe/libfcoe.c:995: error: dereferencing pointer to incomplete type
linux-next-20081229/drivers/scsi/fcoe/libfcoe.c:1015: error: dereferencing pointer to incomplete type

(on netdev->name ?)


Also, libfoce.c has 2 printk's that say "foce:" instead of "fcoe:"...

---
~Randy
