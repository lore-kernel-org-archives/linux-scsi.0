From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] scsi: qla2xxx: Convert timers to use timer_setup()
Date: Tue, 31 Oct 2017 11:28:34 -0700
Message-ID: <CAGXu5j+_OXpxtsgvr4FQvR--sj=hbm124FaMXxxw9kMp-8rTxQ@mail.gmail.com>
References: <20171025100737.GA145097@beast> <yq1d153b9lt.fsf@oracle.com>
 <16733DFA-7339-4F77-9125-E8845C4FCD6F@cavium.com> <1509473546.12927.5.camel@wdc.com>
 <3CE2B08B-07F4-411D-B87A-18F586F5534C@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3CE2B08B-07F4-411D-B87A-18F586F5534C@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 31, 2017 at 11:16 AM, Madhani, Himanshu
<Himanshu.Madhani@cavium.com> wrote:
> Hi Bart,
>
>> On Oct 31, 2017, at 11:12 AM, Bart Van Assche <bart.vanassche@wdc.com> w=
rote:
>>
>> On Tue, 2017-10-31 at 18:03 +0000, Madhani, Himanshu wrote:
>>> On Oct 31, 2017, at 8:49 AM, Martin K. Petersen <martin.petersen@oracle=
.com> wrote:
>>>>> In preparation for unconditionally passing the struct timer_list
>>>>> pointer to all timer callbacks, switch to using the new timer_setup()
>>>>> and from_timer() to pass the timer pointer explicitly.
>>>>
>>>> Cavium folks: Please verify!
>>>
>>> I=E2=80=99ve checked on my setup and i am seeing regression with this p=
atch applied.
>>>
>>> Driver load locks up the system with this patch applied.

How very strange. I don't see any code change with this patch. Even
the passed arguments are the same; it's only enforcing the types now.
And the system is fine with only this patch reverted?

-Kees

>>>
>>> NACK
>>
>> That feedback is not very helpful =E2=80=A6
>>
>
> Here=E2=80=99s my setup details
>
> 4.14.0-rc7 + scsi_misc-4.15 qla2xxx patches from Martin=E2=80=99s tree + =
current patch.
>
> System has 3 adapters 8G/16G/32G.
>
>> Anyway, what kernel source tree did you use in your testing? I may be ab=
le to
>> free up some time to look into this myself.
>>
>> Bart.
>
> Thanks,
> - Himanshu



--=20
Kees Cook
Pixel Security
