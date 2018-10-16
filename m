From: John Stultz <john.stultz@linaro.org>
Subject: Re: [RESEND][PATCH] scsi: ufs: Fix hynix ufs bug with quirk on hi36xx SoC
Date: Tue, 16 Oct 2018 16:50:10 -0700
Message-ID: <CALAqxLX0Q3Yo-75CDdG4g7i5G=i5OPi01ApYyJO6wTn4CSCkPA@mail.gmail.com>
References: <1538434698-1042-1-git-send-email-john.stultz@linaro.org>
 <yq17eiiwobx.fsf@oracle.com> <CALAqxLXYTZZ12haKHGwnTBqPgkv_JF8=fiiJrD9OWRFdcXf0Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALAqxLXYTZZ12haKHGwnTBqPgkv_JF8=fiiJrD9OWRFdcXf0Sw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Wei Li <liwei213@huawei.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Dmitry Shmidt <dimitrysh@google.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 16, 2018 at 3:48 PM, John Stultz <john.stultz@linaro.org> wrote:
> On Mon, Oct 15, 2018 at 8:41 PM, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
>>
>> John,
>>
>>> Hynix ufs has deviations on hi36xx platform which will result in ufs
>>> bursts transfer failures.
>>
>> Is this specific to the particular implementation on hi36xx or all SK
>> Hynix implementations?
>
> I'd have to defer to Wei Li on that question.
>
> Wei Li?

Just to short-cut things a bit, as this is probably an obvious
followup: if it is hi36xx specific, how would you suggest a such a
targeted quirk be added?  I'm not sure I see how to get to the
ufs_dev_desc from the ufs-hisi.c code.

thanks
-john
