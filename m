From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] scsi: qla2xxx: Convert timers to use timer_setup()
Date: Tue, 31 Oct 2017 11:45:20 -0700
Message-ID: <CAGXu5jL7JL2Rw7=PtfEYxzYS1sRx7WO097gizHqHGozetoECfA@mail.gmail.com>
References: <20171025100737.GA145097@beast> <yq1d153b9lt.fsf@oracle.com>
 <16733DFA-7339-4F77-9125-E8845C4FCD6F@cavium.com> <1509473546.12927.5.camel@wdc.com>
 <3CE2B08B-07F4-411D-B87A-18F586F5534C@cavium.com> <CAGXu5j+_OXpxtsgvr4FQvR--sj=hbm124FaMXxxw9kMp-8rTxQ@mail.gmail.com>
 <4AF4B68F-9343-437E-ADA7-1675E32998B9@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4AF4B68F-9343-437E-ADA7-1675E32998B9@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 31, 2017 at 11:36 AM, Madhani, Himanshu
<Himanshu.Madhani@cavium.com> wrote:
> Hi Kees,
>
>> On Oct 31, 2017, at 11:28 AM, Kees Cook <keescook@chromium.org> wrote:
>>
>> How very strange. I don't see any code change with this patch. Even
>> the passed arguments are the same; it's only enforcing the types now.
>> And the system is fine with only this patch reverted?
>
> Yes. Agree patch looks okay, but with the patch built into driver I see
> system going into infinite loop of trying to bring link up and lock up
> after few minutes, Only way to recover is hard reboot.
>
> I reverted this patch after system boot up and rebuild qla2xxx and able
> to load driver.

The patch is a result of three logical steps, so maybe something
unexpected is happening. I'll send the 3 steps broken out...

-Kees

-- 
Kees Cook
Pixel Security
