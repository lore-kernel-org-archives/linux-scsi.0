From: Zhangfei Gao <zhangfei.gao@gmail.com>
Subject: Re: [PATCH 01/11] hisi_sas: add v2 hw support for ECC and AXI bus
 fatal error
Date: Wed, 23 Nov 2016 17:13:52 +0800
Message-ID: <CAMj5Bkg0y5fZDtZstZ84qtWOKV9Hrfj0hMc2LyqxUMnwu=F2zA@mail.gmail.com>
References: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
 <1478522920-108145-2-git-send-email-john.garry@huawei.com>
 <CAMj5BkgAJrky9B8EO+ZZ-hvqnii5+g8nscU4m6fUnizbgEac=w@mail.gmail.com> <ff139f62-fb93-aa19-a8e5-6f9e0d064998@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ff139f62-fb93-aa19-a8e5-6f9e0d064998@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linuxarm@huawei.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Garry <john.garry2@mail.dcu.ie>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 23, 2016 at 4:59 PM, John Garry <john.garry@huawei.com> wrote:
> On 16/11/2016 01:47, Zhangfei Gao wrote:
>>
>> On Mon, Nov 7, 2016 at 8:48 PM, John Garry <john.garry@huawei.com> wrote:
>>>
>>> From: Xiang Chen <chenxiang66@hisilicon.com>

Reviewed-by: Zhangfei Gao <zhangfei.gao@linaro.org>

>>>
>>> For ECC 1bit error, logic can recover it, so we only print
>>> a warning.
>>> For ECC multi-bit and AXI bus fatal error, we panic.
>>
>>
>> Is it possible to recover via resetting phy and device etc instead of
>> panic?
>>
>> Thanks
>>
>>
>
>
> Hi Zhangfei,
>
> We are actually now working on supporting controller reset for certain
> AXI/ECC errors, so that we will not need to panic.

Got it, thanks for the info.

Thanks
