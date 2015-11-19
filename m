From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v5 00/32] HiSilicon SAS driver
Date: Thu, 19 Nov 2015 09:46:56 +0000
Message-ID: <564D9A90.2070304@huawei.com>
References: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
 <yq1egfns0uv.fsf@sermon.lab.mkp.net> <564CB40B.1050705@huawei.com>
 <yq1io4yptmi.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1io4yptmi.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "JBottomley@odin.com" <JBottomley@odin.com>, "robh+dt@kernel.org" <robh+dt@kernel.org>, "pawel.moll@arm.com" <pawel.moll@arm.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, "galak@codeaurora.org" <galak@codeaurora.org>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>, "john.garry2@mail.dcu.ie" <john.garry2@mail.dcu.ie>, "hare@suse.de" <hare@suse.de>, "xuwei (O)" <xuwei5@hisilicon.com>, "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>
List-Id: linux-scsi@vger.kernel.org

On 19/11/2015 03:15, Martin K. Petersen wrote:
>>>>>> "John" == John Garry <john.garry@huawei.com> writes:
>
> John> thanks, please note that we still have the dependency on
> John> http://www.spinics.net/lists/arm-kernel/msg452833.html
>
> John> Without it the driver can only be built into the kernel, and not
> John> as a module.
>
> I have your driver in a staging branch rather than the main 4.5 SCSI
> queue because I wanted to see what kind of additional fallout I'd get
> from the zeroday testing.
>
> It's not a problem for me to wait for that patch to go in (or take it
> through SCSI if that makes things easier).
>

The issue is the I don't know if Rob will approve the requested patch.

As an alternative I can make my driver not depend on it. So I could make 
a v6 patchset or just send a supplementary patch on top of v5 patchset.

Thanks,
John
