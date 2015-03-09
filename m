From: "Chentao (Boby)" <boby.chen@huawei.com>
Subject: Re: [PATCH v2] xen-scsiback: use DRV_PFX in the pr macros and DPRINTK
Date: Mon, 9 Mar 2015 21:59:46 +0800
Message-ID: <54FDA752.90302@huawei.com>
References: <1425493951-41801-1-git-send-email-boby.chen@huawei.com>	 <1425486739.2712.12.camel@perches.com> <54F97456.2070102@huawei.com> <1425646243.12017.28.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425646243.12017.28.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: jgross@suse.com, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com, david.vrabel@citrix.com, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, wu.wubin@huawei.com, rudy.zhangmin@huawei.com
List-Id: linux-scsi@vger.kernel.org



On 2015/3/6 20:50, Joe Perches wrote:
> On Fri, 2015-03-06 at 17:33 +0800, Chentao (Boby) wrote:
>> #ifdef pr_fmt
>> #undef pr_fmt
>> #endif
>> #define pr_fmt(fmt) "xen-pvscsi: " fmt
>
> No, just use add
> #define pr_fmt(fmt) "xen-pvscsi: " fmt
> before the first #include.
> The #ifdef/#undef/#endif isn't necessary.
>
>> Then replace all DPRINTK with pr_debug.
>
> Yes on this one.
>

Thanks very much, Joe.

>
>
>
> .
>
