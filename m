From: "Shi, Yang" <yang.shi@linaro.org>
Subject: Re: [PATCH] scsi: fdomain: add missing CONFIG_ to PCMCIA
Date: Tue, 9 Feb 2016 15:28:31 -0800
Message-ID: <56BA761F.4000305@linaro.org>
References: <1455056209-1696-1-git-send-email-yang.shi@linaro.org>
 <20160209232510.0c38ff77@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160209232510.0c38ff77@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: JBottomley@odin.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linaro-kernel@lists.linaro.org
List-Id: linux-scsi@vger.kernel.org

On 2/9/2016 3:25 PM, One Thousand Gnomes wrote:
> On Tue,  9 Feb 2016 14:16:49 -0800
> Yang Shi <yang.shi@linaro.org> wrote:
>
>> There are some "#ifdef PCMCIA" in the driver code, but all of them missed
>> CONFIG_ prefix. Correct PCMCIA to CONFIG_PCMCIA.
>>
>> Signed-off-by: Yang Shi <yang.shi@linaro.org>
>
> NAK. This breaks the driver completely
>
>
> Read drivers/scsi/pcmcia/fdomain*

Got it. Thanks for spotting out this. Sorry for the unthought change.

Yang

>
> Alan
>
