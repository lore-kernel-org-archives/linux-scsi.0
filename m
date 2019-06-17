From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [RFC v2 00/11] DVFS in the OPP core
Date: Mon, 17 Jun 2019 09:56:54 +0530
Message-ID: <20190617042654.xdqx5naxo3lq7kv6@vireshk-i7>
References: <20190320094918.20234-1-rnayak@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190320094918.20234-1-rnayak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Rajendra Nayak <rnayak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org, linux-serial@vger.kernel.org, linux-spi@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, swboyd@chromium.org, ulf.hansson@linaro.org, dianders@chromium.org, rafael@kernel.org
List-Id: linux-scsi@vger.kernel.org

On 20-03-19, 15:19, Rajendra Nayak wrote:
> This is a v2 of the RFC posted earlier by Stephen Boyd [1]
> 
> As part of v2 I still follow the same approach of dev_pm_opp_set_rate()
> API using clk framework to round the frequency passed and making it
> accept 0 as a valid frequency indicating the frequency isn't required
> anymore. It just has a few more drivers converted to use this approach
> like dsi/dpu and ufs.
> ufs demonstrates the case of having to handle multiple power domains, one
> of which is scalable.
> 
> The patches are based on 5.1-rc1 and depend on some ufs fixes I posted
> earlier [2] and a DT patch to include the rpmpd header [3]
> 
> [1] https://lkml.org/lkml/2019/1/28/2086
> [2] https://lkml.org/lkml/2019/3/8/70
> [3] https://lkml.org/lkml/2019/3/20/120
> 
> Rajendra Nayak (10):
>   OPP: Make dev_pm_opp_set_rate() with freq=0 as valid
> 
> Stephen Boyd (1):
>   OPP: Don't overwrite rounded clk rate

I have applied modified version of these two patches to the OPP tree now.
Thanks.

-- 
viresh
