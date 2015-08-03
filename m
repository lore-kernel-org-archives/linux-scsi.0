From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: blk-mq vs kmemleak
Date: Mon, 3 Aug 2015 10:05:59 -0700
Message-ID: <55BF9F77.90906@sandisk.com>
References: <20150703161137.GA10438@codemonkey.org.uk>
 <5596C080.4050009@sandisk.com>
 <20150707103323.GA13228@e104818-lin.cambridge.arm.com>
 <559BDB49.70209@sandisk.com> <20150708081740.GA3374@infradead.org>
 <55BC14AE.3090200@sandisk.com>
 <20150803104309.GB4033@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0088.outbound.protection.outlook.com ([65.55.169.88]:43664
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753466AbbHCRGH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Aug 2015 13:06:07 -0400
In-Reply-To: <20150803104309.GB4033@e104818-lin.cambridge.arm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@codemonkey.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 08/03/2015 03:43 AM, Catalin Marinas wrote:
> The pages allocated for struct request contain pointers to other slab
> allocations (via ops->init_request). Since kmemleak does not track/scan
> page allocations, the slab objects will be reported as leaks (false
> positives). This patch adds kmemleak callbacks to allow tracking of such
> pages.
>
> Signed-off-by: Catalin Marinas<catalin.marinas@arm.com>
> Reported-by: Bart Van Assche<bart.vanassche@sandisk.com>

That patch works fine on my test setup, hence:

Tested-by: Bart Van Assche<bart.vanassche@sandisk.com>

Thanks !

Bart.
