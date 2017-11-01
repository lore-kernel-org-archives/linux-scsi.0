From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 0/4] scsi: qla2xxx: Convert timers to use timer_setup()
Date: Wed, 1 Nov 2017 19:18:41 +0000
Message-ID: <F16A8DFC-AF77-44A0-BDC8-F0197A314123@cavium.com>
References: <1509477229-62141-1-git-send-email-keescook@chromium.org>
 <CAGXu5jJnB9rAN_qjrdh3iGfWtB2-p5dqNOtqScnSZn9j20iFgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJnB9rAN_qjrdh3iGfWtB2-p5dqNOtqScnSZn9j20iFgg@mail.gmail.com>
Content-Language: en-US
Content-ID: <8593F4F713F2874F852E16144C8E016E@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

Hi Kees,=20

> On Nov 1, 2017, at 11:46 AM, Kees Cook <keescook@chromium.org> wrote:
>=20
> On Tue, Oct 31, 2017 at 12:13 PM, Kees Cook <keescook@chromium.org> wrote=
:
>> This breaks out the logical steps to convert the qla2xxx timers:
>>=20
>> 1) init_timer() -> setup_timer()
>> 2) refactor qla2x00_start_timer() to not pass callback as argument
>> 3) qla2x00_timer() to use timer_setup()
>> 4) qla2x00_sp_timeout() to use timer_setup()
>>=20
>> The resulting diff is identical to the patch that appears to lock up
>> the driver. This should help identify which step causes this behavior.
>=20
> Hi, just curious if there's been any progress on debugging the issue
> you saw with this series?
>=20

Sorry for delay. I will test this series later today and post update.=20

> Thanks!
>=20
> -Kees
>=20
> --=20
> Kees Cook
> Pixel Security

Thanks,
- Himanshu
