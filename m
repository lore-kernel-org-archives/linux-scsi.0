From: Yadan Fan <ydfan@suse.com>
Subject: Re: [PATCH 1/2] hpsa: limit transfer length to 1MB
Date: Fri, 23 Jun 2017 17:12:54 +0800
Message-ID: <75d55466-a883-3335-ad96-9baff4b907cd@suse.com>
References: <20170622095845.4235-1-ydfan@suse.com>
 <20170622100657.GG5670@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170622100657.GG5670@linux-x5ow.site>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: don.brace@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Johannes,


On 2017年06月22日 18:06, Johannes Thumshirn wrote:
> On Thu, Jun 22, 2017 at 05:58:44PM +0800, Yadan Fan wrote:
>> The hpsa firmware will bypass the cache for any request larger
>> than 1MB, so we should cap the request size to avoid any
>> performance degradation in SLE12-SP2.
> Upstream doesn't care too much about SLES.
>
>> References: bsc#1025461
> and our internal Bugzilla IDs
>
>
> How about:
> The hpsa firmware will bypass the cache for any requests larger than 1MB, so
> we shoould cap the request size to avoid any performance regressions in
> kernels later than 4.3
>
> The same applies for Patch 2/2

Yes, I agree so, I will resend the modified patches.

Thanks,
Yadan
