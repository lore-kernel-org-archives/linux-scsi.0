From: "Chentao (Boby)" <boby.chen@huawei.com>
Subject: Re: [PATCH v2] xen-scsiback: use DRV_PFX in the pr macros and DPRINTK
Date: Fri, 6 Mar 2015 17:39:32 +0800
Message-ID: <54F975D4.9020503@huawei.com>
References: <1425493951-41801-1-git-send-email-boby.chen@huawei.com> <54F6DFB7.2080402@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54F6DFB7.2080402@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Vrabel <david.vrabel@citrix.com>, jgross@suse.com, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com
Cc: xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, wu.wubin@huawei.com, rudy.zhangmin@huawei.com
List-Id: linux-scsi@vger.kernel.org


On 2015/3/4 18:34, David Vrabel wrote:
> On 04/03/15 18:32, Tao Chen wrote:
>> Defined the string of {xen-pvscsi: } as DRV_PFX, then use it in the pr sentences and DPRINTK.
>> Also fixed up some comments just as eliminate redundant white spaces and format the code.
>> These will make the code easier to read.
>
> I have already said you needed to use:
>
> #define pr_fmt(fmt)
>
> to do this.
>
> David
>
> .
>

David, I'm sorry because I didn't read your reply in time.

I will accept your advice in my next patch. Many thanks to you.
