From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: Re: [PATCH 1/1] scsi/ufshcd: Fix NULL pointer dereference for in ufshcd_init
Date: Wed, 26 Sep 2018 11:47:21 +0530
Message-ID: <CAFp+6iGr6w3BLz14LYS=DVDhBSeE=Z6dSC8pFjpFHa5OWGAJbQ@mail.gmail.com>
References: <20180807174739.23379-1-vivek.gautam@codeaurora.org>
 <CAE=gft5ONyVQ6qkP41G_vx-Djo0MqHhXZ6pjTOZjTDpPgwukZQ@mail.gmail.com>
 <CAFp+6iEpZThehq4896dmYifvbNF5wa3ESyw7yBv7vpUbtQKzhA@mail.gmail.com>
 <CAFp+6iFVQKvWj7o+nmoJVhgQpOz2gZ_Eo+e8c8qdoc18waJ+zw@mail.gmail.com> <yq1lg7pgjb4.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1lg7pgjb4.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, evgreen@chromium.org, linux-scsi@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Subhash Jadavani <subhashj@codeaurora.org>, mka@chromium.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 26, 2018 at 6:36 AM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Vivek,
>
> >> > > Bjorn, Subhash,
> >> > > I am not certain of some of these devfreq, and clk_scaling bits
> >> > > that are moved as part of this patch. Please help in reviewing the
> >> > > change in the light of these features, and related sequence should
> >> > > be followed.
> >> > > Thanks.
> >> > >
> >> >
> >> > You're right, there is a lot of logic moving around here. I think this
> >> > looks okay to me.
> >> >
> >> > Reviewed-by: Evan Green <evgreen@chromium.org>
> >>
> >> Thanks Evan.
> >>
> >> Best regards
> >> Vivek
> >
> > Gentle ping. Will you please consider picking this patch for the
> > merge?
>
> I was waiting for some feedback from Bjorn or Subhash.
Sure.

Bjorn, Subhash, gentle ping. How does this change look to you?
Would appreciate if you could please review this. Thanks.

Best regards
Vivek
>
> --
> Martin K. Petersen      Oracle Linux Engineering



-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
