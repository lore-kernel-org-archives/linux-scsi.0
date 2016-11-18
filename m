From: John Garry <john.garry@huawei.com>
Subject: Re: [RFC PATCH] scsi: libsas: fix WARN on device removal
Date: Fri, 18 Nov 2016 09:00:54 +0000
Message-ID: <ca8ce351-ae6c-6878-4cd7-af7af11122ad@huawei.com>
References: <1478185120-5509-1-git-send-email-john.garry@huawei.com>
 <be84afd4-640d-1913-404a-505fd72c1324@huawei.com>
 <b800ae5c-f275-728c-27b4-230663757781@huawei.com>
 <CAPcyv4g+XzCuHsUvqeE+r8hqgPK3yq=E9k23a89XcLs96bkphg@mail.gmail.com>
 <CAPcyv4hvuFLhS2sYXkccXMTSh-ggxo7uHN2Qt6i5g8GkyBksrw@mail.gmail.com>
 <9870e7bc-a472-1913-1930-ac022e8ad5e8@huawei.com>
 <58257D52.6090507@huawei.com>
 <93ae84f6-75a2-f576-808e-f98c6256b6a6@huawei.com>
 <58258631.1090203@huawei.com>
 <9bdd2ca5-aa72-6a18-b66d-8e791e4852c7@huawei.com>
 <CAPcyv4g7_kDAZNZ2ikBRgFsX-hFpcXEV2xg9YS0Ha7PjSBkzVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4g7_kDAZNZ2ikBRgFsX-hFpcXEV2xg9YS0Ha7PjSBkzVQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, wangyijing <wangyijing@huawei.com>, linux-scsi <linux-scsi@vger.kernel.org>, John Garry <john.garry2@mail.dcu.ie>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linuxarm@huawei.com, lindar_liu@usish.com, Tejun Heo <tj@kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>
List-Id: linux-scsi@vger.kernel.org

On 18/11/2016 01:53, Dan Williams wrote:
> On Thu, Nov 17, 2016 at 7:23 AM, John Garry <john.garry@huawei.com> wrote:
>> On 11/11/2016 08:49, wangyijing wrote:
>>>>>>
>>>>>> I have not seen the flutter issue. I am just trying to solve the
>>>>>> horrible WARN dump.
>>>>>> However I do understand that there may be a issue related to how we
>>>>>> queue the events; there was a recent attempt to fix this, but it came to
>>>>>> nothing:
>>>>>> https://www.spinics.net/lists/linux-scsi/msg99991.html
>>>>>
>>>>>
>>>>> We found libsas hotplug several problems:
>>>>> 1. sysfs warning calltrace(like the case you found);
>>>>
>>>>
>>>> Maybe you can then review my patch.
>>>
>>>
>>> I did it, I think your solution to fix the sysfs calltrace issue is ok,
>>> and what I worried about is we still need to fix
>>> the rest issues. So it's better if we could fix all issues one time.
>>>
>>
>> @Maintainers, would you be willing to accept this patch as an interim fix
>> for the dastardly WARN while we try to fix the flutter issue?
>
> To me this adds a bug to quiet a benign, albeit noisy, warning.
>

What is the bug which is being added?

And it's a very noisy warning, as in 6K lines on the console when an 
expander is unplugged.

> .
>
