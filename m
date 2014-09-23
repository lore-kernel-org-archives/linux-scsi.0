From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: Re: [PATCH V4 09/17] scsi: ufs: manually add well known logical
 units
Date: Tue, 23 Sep 2014 11:48:54 -0000
Message-ID: <fe5615989f4f99067ddb8695a4a046e1.squirrel@www.codeaurora.org>
References: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>
    <1411457499-8074-10-git-send-email-draviv@codeaurora.org>
    <20140923083532.GB28647@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20140923083532.GB28647@infradead.org>
Sender: linux-arm-msm-owner@vger.kernel.org
Cc: Dolev Raviv <draviv@codeaurora.org>, james.bottomley@hansenpartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org


> None of the REPORT LUNS language makes sense as we're not using it.
>
> Can you respon the patch with a better description, and a little comment
> in the code on why you're adding these wluns.

ok.

>
> Also can I assume none of the later patches relies on their existance?

In UFS power management commands such as SSU, are sent to "device w-
lun". Leaving it out should only affect the ability to suspend the
device.
Other patches are not directly affected by it.

> If you do you need to check the error return from scsi_add_device, if
> not said comment should mention why it's fine to not actually find
> any of these.
>

Will discus it further with Subhash.

> Also if you do use one of them from kernel space later it might make
> more sense to use __scsi_add_device and store a pointer to the
> scsi_device instead of looking it up later.
>

I'll review all you suggestions with Subhash.


-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
