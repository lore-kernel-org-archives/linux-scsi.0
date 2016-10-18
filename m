From: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2 01/10] phy: qcom-ufs: remove failure when
 rx/tx_iface_clk are absent
Date: Tue, 18 Oct 2016 14:18:52 -0700
Message-ID: <3ecf01cc-b9b1-046e-57b8-2bb855b9ac5d@codeaurora.org>
References: <1476800897-19898-1-git-send-email-vivek.gautam@codeaurora.org>
 <1476800897-19898-2-git-send-email-vivek.gautam@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1476800897-19898-2-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>, kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Cc: subhashj@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Yaniv Gardi <ygardi@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

On 10/18/2016 07:28 AM, Vivek Gautam wrote:
> From: Yaniv Gardi <ygardi@codeaurora.org>
>
> Since in future UFS Phy's the tx_iface_clk and rx_iface_clk
> are no longer exist, we should not fail when their initialization
> fail, but rather just report with debug message.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
> ---

Shouldn't we have a different compatible string on future UFS phys so
that we know which number of clks and what clks are required? That's how
we typically handle clk configurations changing. Making them optional
should really only be needed when they're really optional, i.e. things
will work fine if they're there or not.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
