From: Drunkard Zhang <gongfan193@gmail.com>
Subject: Re: mvsas regression since 3.5
Date: Sun, 23 Dec 2012 16:26:47 +0800
Message-ID: <CAJiejCQXQWztiA8ksfRmxqx969FFpuL3DXH=EXmbOkYHE6VA5g@mail.gmail.com>
References: <CAJiejCRCXgCw957to0fWhQPS69doacY9DOaQMpfyxM4bm3igQw@mail.gmail.com>
 <50D6AFF2.1010708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50D6AFF2.1010708@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xi Wang <xi.wang@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Dan Williams <dan.j.williams@intel.com>, Jack Wang <jack_wang@usish.com>, Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

2012/12/23 Xi Wang <xi.wang@gmail.com>:
> On 12/22/12 10:33 AM, Drunkard Zhang wrote:
>> I'm using Asus PIKE 6480 SAS card, whose chipset is "RAID bus
>> controller: Marvell Technology Group Ltd. MV64460/64461/64462 System
>> Controller, Revision B", with latest stable branch 3.7.1 only 1 of 8
>> ports works, to get others works I got to pull & plug back. While with
>> 3.5.7 it's all good, so it must be a regression.
>
> Can you try to revert commit beecadea1b8d67f591b13f7099559f32f3fd601d?
>
> Particularly, can you first change
>
>   #define bit(n) ((u64)1 << n)
>
> in drivers/scsi/mvsas/mv_sas.h back to
>
>   #define bit(n) ((u32)1 << n)
>
> and see if it works for you?  Thanks.
>

Thanks for reply.

This commit just applied in v3.8-rc1, so can't be it. I'm testing
related commits too...
