From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] hpsa: limit transfer length to 1MB
Date: Thu, 22 Jun 2017 12:06:57 +0200
Message-ID: <20170622100657.GG5670@linux-x5ow.site>
References: <20170622095845.4235-1-ydfan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170622095845.4235-1-ydfan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yadan Fan <ydfan@suse.com>
Cc: don.brace@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 22, 2017 at 05:58:44PM +0800, Yadan Fan wrote:
> The hpsa firmware will bypass the cache for any request larger
> than 1MB, so we should cap the request size to avoid any
> performance degradation in SLE12-SP2.
Upstream doesn't care too much about SLES. 

> References: bsc#1025461

and our internal Bugzilla IDs


How about:
The hpsa firmware will bypass the cache for any requests larger than 1MB, so
we shoould cap the request size to avoid any performance regressions in
kernels later than 4.3 

The same applies for Patch 2/2

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
