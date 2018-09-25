From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: Re: [PATCH 1/1] scsi/ufshcd: Fix NULL pointer dereference for in ufshcd_init
Date: Tue, 25 Sep 2018 15:20:43 +0530
Message-ID: <CAFp+6iFVQKvWj7o+nmoJVhgQpOz2gZ_Eo+e8c8qdoc18waJ+zw@mail.gmail.com>
References: <20180807174739.23379-1-vivek.gautam@codeaurora.org>
 <CAE=gft5ONyVQ6qkP41G_vx-Djo0MqHhXZ6pjTOZjTDpPgwukZQ@mail.gmail.com> <CAFp+6iEpZThehq4896dmYifvbNF5wa3ESyw7yBv7vpUbtQKzhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFp+6iEpZThehq4896dmYifvbNF5wa3ESyw7yBv7vpUbtQKzhA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, evgreen@chromium.org, linux-scsi@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Subhash Jadavani <subhashj@codeaurora.org>, mka@chromium.org
List-Id: linux-scsi@vger.kernel.org

Hi Martin,

On Wed, Aug 29, 2018 at 1:50 PM Vivek Gautam
<vivek.gautam@codeaurora.org> wrote:
>
> On Wed, Aug 29, 2018 at 1:13 AM Evan Green <evgreen@chromium.org> wrote:
> >
> > On Tue, Aug 7, 2018 at 10:48 AM Vivek Gautam
> > <vivek.gautam@codeaurora.org> wrote:
> > >
> > > Error paths in ufshcd_init() ufshcd_hba_exit() killed clk_scaling
> > > workqueue when the workqueue is actually created quite late in
> > > ufshcd_init().
> > > So, we end up getting NULL pointer dereference in such error paths.
> > > Fix this by moving clk_scaling initialization and kill codes to
> > > two separate methods, and call them at required places.
> > >
> > > Fixes: 401f1e4490ee ("scsi: ufs: don't suspend clock scaling during clock
> > > gating")
> > >
> > > Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
> > > Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> > > Cc: Subhash Jadavani <subhashj@codeaurora.org>
> > > Cc: Matthias Kaehlcke <mka@chromium.org>
> > > Cc: Evan Green <evgreen@chromium.org>
> > > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> > > ---
> > >
> > > Bjorn, Subhash,
> > > I am not certain of some of these devfreq, and clk_scaling bits
> > > that are moved as part of this patch. Please help in reviewing the
> > > change in the light of these features, and related sequence should
> > > be followed.
> > > Thanks.
> > >
> >
> > You're right, there is a lot of logic moving around here. I think this
> > looks okay to me.
> >
> > Reviewed-by: Evan Green <evgreen@chromium.org>
>
> Thanks Evan.
>
> Best regards
> Vivek

Gentle ping. Will you please consider picking this patch for the merge?
Thanks
Vivek

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
