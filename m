From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi/ufshcd: Fix NULL pointer dereference for in ufshcd_init
Date: Tue, 25 Sep 2018 21:05:03 -0400
Message-ID: <yq1lg7pgjb4.fsf@oracle.com>
References: <20180807174739.23379-1-vivek.gautam@codeaurora.org>
        <CAE=gft5ONyVQ6qkP41G_vx-Djo0MqHhXZ6pjTOZjTDpPgwukZQ@mail.gmail.com>
        <CAFp+6iEpZThehq4896dmYifvbNF5wa3ESyw7yBv7vpUbtQKzhA@mail.gmail.com>
        <CAFp+6iFVQKvWj7o+nmoJVhgQpOz2gZ_Eo+e8c8qdoc18waJ+zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFp+6iFVQKvWj7o+nmoJVhgQpOz2gZ_Eo+e8c8qdoc18waJ+zw@mail.gmail.com>
        (Vivek Gautam's message of "Tue, 25 Sep 2018 15:20:43 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@linux.vnet.ibm.com, evgreen@chromium.org, linux-scsi@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Subhash Jadavani <subhashj@codeaurora.org>, mka@chromium.org
List-Id: linux-scsi@vger.kernel.org


Vivek,

>> > > Bjorn, Subhash,
>> > > I am not certain of some of these devfreq, and clk_scaling bits
>> > > that are moved as part of this patch. Please help in reviewing the
>> > > change in the light of these features, and related sequence should
>> > > be followed.
>> > > Thanks.
>> > >
>> >
>> > You're right, there is a lot of logic moving around here. I think this
>> > looks okay to me.
>> >
>> > Reviewed-by: Evan Green <evgreen@chromium.org>
>>
>> Thanks Evan.
>>
>> Best regards
>> Vivek
>
> Gentle ping. Will you please consider picking this patch for the
> merge?

I was waiting for some feedback from Bjorn or Subhash.

-- 
Martin K. Petersen	Oracle Linux Engineering
