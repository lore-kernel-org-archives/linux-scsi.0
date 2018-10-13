From: cang@codeaurora.org
Subject: Re: [PATCH v3 1/1] scsi: ufs: make UFS Tx lane1 clock optional for
 QCOM platforms
Date: Sat, 13 Oct 2018 10:13:02 +0800
Message-ID: <5f2d152941aed6411f54d47dd7ec199e@codeaurora.org>
References: <1539306736-9519-1-git-send-email-cang@codeaurora.org>
 <CAD=FV=WjO9YvKHDiEDt8+8TJ_JjnzcVAqB99nhP5LwnWO0fuLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAD=FV=WjO9YvKHDiEDt8+8TJ_JjnzcVAqB99nhP5LwnWO0fuLw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Anderson <dianders@chromium.org>
Cc: subhashj@codeaurora.org, Asutosh Das <asutoshd@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Evan Green <evgreen@chromium.org>, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-arm-msm <linux-arm-msm@vger.kernel.org>, venkatg@codeaurora.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2018-10-13 00:55, Doug Anderson wrote:
> Hi,
> 
> On Thu, Oct 11, 2018 at 6:12 PM Can Guo <cang@codeaurora.org> wrote:
>> +       if (err != -EPROBE_DEFER)
>> +               dev_err(dev, "failed to get %s err %d",
>> +                               name, err);
> 
> I wouldn't spin just for this, but if you spin for some other reason
> you could move the above "dev_err" onto one line now.  Sorry: I should
> have noticed that / done that on my patch...
> 
> 

Yeah... I didn't notice it too. Shall push a new one to address it.

>> @@ -141,24 +147,21 @@ static int ufs_qcom_enable_lane_clks(struct 
>> ufs_qcom_host *host)
> 
> Idea for a future patch: now that I look at what's left of this
> function you're basically re-implementing clk_bulk_prepare_enable()
> and clk_bulk_disable_unprepare() now.  I bet your code would be
> cleaner / nicer by switching to that.
> 
> ...possibly you might need to improve the clk_bulk_get() API to allow
> for some clock to be optional, but that would be a pretty easy patch
> to post up.
> 
> In any case I think it's better to do the clk_bulk switch in a future
> / separate patch, so:
> 
> Reviewed-by: Douglas Anderson <dianders@chromium.org>
> Tested-by: Douglas Anderson <dianders@chromium.org>
> 
> 
> -Doug

That is a good idea, I shall follow up after this one is merged.

Thank you.
-Can Guo
