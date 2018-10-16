From: John Stultz <john.stultz@linaro.org>
Subject: Re: [RESEND][PATCH] scsi: ufs: Fix hynix ufs bug with quirk on hi36xx SoC
Date: Tue, 16 Oct 2018 15:48:12 -0700
Message-ID: <CALAqxLXYTZZ12haKHGwnTBqPgkv_JF8=fiiJrD9OWRFdcXf0Sw@mail.gmail.com>
References: <1538434698-1042-1-git-send-email-john.stultz@linaro.org> <yq17eiiwobx.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq17eiiwobx.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Wei Li <liwei213@huawei.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Dmitry Shmidt <dimitrysh@google.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 15, 2018 at 8:41 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> John,
>
>> Hynix ufs has deviations on hi36xx platform which will result in ufs
>> bursts transfer failures.
>
> Is this specific to the particular implementation on hi36xx or all SK
> Hynix implementations?

I'd have to defer to Wei Li on that question.

Wei Li?


>> +     UFS_FIX(UFS_VENDOR_SKHYNIX, UFS_ANY_MODEL,
>> +             UFS_DEVICE_QUIRK_HOST_VS_DEBUGSAVECONFIGTIME),
>
> I am not so keen on matching on all current and future models.

I'll see if I can narrow down the affected model version on the board
I have. Hopefully it doesn't vary too much.

Really appreciate the review and the feedback!

thanks
-john
