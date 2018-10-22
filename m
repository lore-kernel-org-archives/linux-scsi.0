From: John Stultz <john.stultz@linaro.org>
Subject: Re: [RESEND][PATCH] scsi: ufs: Fix hynix ufs bug with quirk on hi36xx SoC
Date: Mon, 22 Oct 2018 10:21:35 -0700
Message-ID: <CALAqxLWv1v+JiLjwJpQ_rFkwM4d86YRr1WeMLjg4=Wvwpd5MGw@mail.gmail.com>
References: <1538434698-1042-1-git-send-email-john.stultz@linaro.org>
 <yq17eiiwobx.fsf@oracle.com> <CALAqxLXYTZZ12haKHGwnTBqPgkv_JF8=fiiJrD9OWRFdcXf0Sw@mail.gmail.com>
 <CALAqxLX0Q3Yo-75CDdG4g7i5G=i5OPi01ApYyJO6wTn4CSCkPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALAqxLX0Q3Yo-75CDdG4g7i5G=i5OPi01ApYyJO6wTn4CSCkPA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Wei Li <liwei213@huawei.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Dmitry Shmidt <dimitrysh@google.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 16, 2018 at 4:50 PM, John Stultz <john.stultz@linaro.org> wrote:
> On Tue, Oct 16, 2018 at 3:48 PM, John Stultz <john.stultz@linaro.org> wrote:
>> On Mon, Oct 15, 2018 at 8:41 PM, Martin K. Petersen
>> <martin.petersen@oracle.com> wrote:
>>>
>>> John,
>>>
>>>> Hynix ufs has deviations on hi36xx platform which will result in ufs
>>>> bursts transfer failures.
>>>
>>> Is this specific to the particular implementation on hi36xx or all SK
>>> Hynix implementations?
>>
>> I'd have to defer to Wei Li on that question.

So I followed up with Wei Li and it seems its something specific to
hi36xx that the specific hynix chip brings out, which most other chips
don't seem to trigger.


> Just to short-cut things a bit, as this is probably an obvious
> followup: if it is hi36xx specific, how would you suggest a such a
> targeted quirk be added?  I'm not sure I see how to get to the
> ufs_dev_desc from the ufs-hisi.c code.

So yea, I've already reworked the quirk to be specific to the one
model of hynix chip, but I'm still a bit confused on best practices
for handling these quirks on the controller side. If there's a pointer
to similar controller side quirks that are device specific, I'd be
glad to rework the patch in that fashion. Otherwise I'll just try to
figure out how to get to the ufs_dev_desc from ufs-hisi.c

thanks
-john
