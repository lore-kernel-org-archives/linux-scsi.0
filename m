From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] hisi_sas: use platform_get_irq()
Date: Fri, 11 Dec 2015 10:13:28 +0000
Message-ID: <566AA1C8.3060803@huawei.com>
References: <1449759745-63498-1-git-send-email-john.garry@huawei.com>
 <CAL_Jsq+TMtZ1H6itwwXDrmt2TPuM8c02WiM0mDj-AUVgwvBt7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:14713 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbbLKKOX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2015 05:14:23 -0500
In-Reply-To: <CAL_Jsq+TMtZ1H6itwwXDrmt2TPuM8c02WiM0mDj-AUVgwvBt7w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Herring <robh@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, martin.petersen@oracle.com, Arnd Bergmann <arnd@arndb.de>, Linuxarm <linuxarm@huawei.com>, Zhangfei Gao <zhangfei.gao@linaro.org>, Wei Xu <xuwei5@hisilicon.com>, John Garry <john.garry2@mail.dcu.ie>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 10/12/2015 20:08, Rob Herring wrote:
> On Thu, Dec 10, 2015 at 9:02 AM, John Garry <john.garry@huawei.com> wrote:
>> It is preferred that drivers use platform_get_irq()
>> instead of irq_of_parse_and_map(), so replace.
>
> You may be able to stop including of_irq.h with this change. Otherwise,
>

Right, I don't think it is required any longer. I'll generate another patch.

Thanks,


