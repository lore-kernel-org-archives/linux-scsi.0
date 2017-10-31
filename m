From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH] scsi: qla2xxx: Convert timers to use timer_setup()
Date: Tue, 31 Oct 2017 18:36:07 +0000
Message-ID: <4AF4B68F-9343-437E-ADA7-1675E32998B9@cavium.com>
References: <20171025100737.GA145097@beast> <yq1d153b9lt.fsf@oracle.com>
 <16733DFA-7339-4F77-9125-E8845C4FCD6F@cavium.com>
 <1509473546.12927.5.camel@wdc.com>
 <3CE2B08B-07F4-411D-B87A-18F586F5534C@cavium.com>
 <CAGXu5j+_OXpxtsgvr4FQvR--sj=hbm124FaMXxxw9kMp-8rTxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0084.outbound.protection.outlook.com ([104.47.42.84]:38542
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932423AbdJaSgJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Oct 2017 14:36:09 -0400
In-Reply-To: <CAGXu5j+_OXpxtsgvr4FQvR--sj=hbm124FaMXxxw9kMp-8rTxQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <434A67F52B6693409FCA4E3A30255C59@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>

Hi Kees,=20

> On Oct 31, 2017, at 11:28 AM, Kees Cook <keescook@chromium.org> wrote:
>=20
> How very strange. I don't see any code change with this patch. Even
> the passed arguments are the same; it's only enforcing the types now.
> And the system is fine with only this patch reverted?

Yes. Agree patch looks okay, but with the patch built into driver I see
system going into infinite loop of trying to bring link up and lock up=20
after few minutes, Only way to recover is hard reboot.=20

I reverted this patch after system boot up and rebuild qla2xxx and able
to load driver.

Thanks,
- Himanshu
