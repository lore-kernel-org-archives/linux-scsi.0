From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: Re: [PATCH v2 01/10] phy: qcom-ufs: remove failure when
 rx/tx_iface_clk are absent
Date: Wed, 19 Oct 2016 22:50:15 +0530
Message-ID: <CAFp+6iEktHGZioT9zm8WK2wM+RYS9u9ZRjSbB9i=WLnJVHW0Vg@mail.gmail.com>
References: <1476800897-19898-1-git-send-email-vivek.gautam@codeaurora.org>
 <1476800897-19898-2-git-send-email-vivek.gautam@codeaurora.org> <3ecf01cc-b9b1-046e-57b8-2bb855b9ac5d@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3ecf01cc-b9b1-046e-57b8-2bb855b9ac5d@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: kishon <kishon@ti.com>, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, subhashj@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Yaniv Gardi <ygardi@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Hi,


On Wed, Oct 19, 2016 at 2:48 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 10/18/2016 07:28 AM, Vivek Gautam wrote:
>> From: Yaniv Gardi <ygardi@codeaurora.org>
>>
>> Since in future UFS Phy's the tx_iface_clk and rx_iface_clk
>> are no longer exist, we should not fail when their initialization
>> fail, but rather just report with debug message.
>>
>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
>> ---
>
> Shouldn't we have a different compatible string on future UFS phys so
> that we know which number of clks and what clks are required? That's how
> we typically handle clk configurations changing. Making them optional
> should really only be needed when they're really optional, i.e. things
> will work fine if they're there or not.

Correct. It makes sense to have different compatible strings for different
versions.
I will gather more information about previous versions that required
this clock, and update as suggested.


Regards
Vivek


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
