From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 2/2] smartpqi: limit transfer length to 1MB
Date: Fri, 23 Jun 2017 15:01:41 +0200
Message-ID: <20170623130141.GE13014@linux-x5ow.site>
References: <20170623094006.16807-1-ydfan@suse.com>
 <20170623094006.16807-2-ydfan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170623094006.16807-2-ydfan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yadan Fan <ydfan@suse.com>
Cc: don.brace@microsemi.com, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 23, 2017 at 05:40:06PM +0800, Yadan Fan wrote:
> The smartpqi firmware will bypass the cache for any request larger
> than 1MB, so we should cap the request size to avoid any
> performance degradation in kernels later than v4.3
> 
> This degradation is caused from d2be537c3ba3568acd79cd178327b842e60d035e,
> which changed max_sectors_kb to 1280k, but the hardware is able to
> work fine with it, so the true fix should be from smartpqi driver.
> 
> Signed-off-by: Yadan Fan <ydfan@suse.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
