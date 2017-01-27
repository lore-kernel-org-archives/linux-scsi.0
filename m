From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi: srp_transport: Fix 'always false comparison' in
 srp_tmo_valid()
Date: Fri, 27 Jan 2017 19:42:28 +0000
Message-ID: <1485546128.4267.25.camel@sandisk.com>
References: <1485429447-19103-1-git-send-email-augustocaringi@gmail.com>
         <1485443483.2980.1.camel@sandisk.com>
         <CADFy_4HK9nxcB0xn6_Hw6xVKgJKVuVfkFPTsfQSoe-bJc6gGMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADFy_4HK9nxcB0xn6_Hw6xVKgJKVuVfkFPTsfQSoe-bJc6gGMw@mail.gmail.com>
Content-Language: en-US
Content-ID: <97F84E9FD4D3E144A338E0C7C03CCA53@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "augustocaringi@gmail.com" <augustocaringi@gmail.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "emilne@redhat.com" <emilne@redhat.com>, "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "sagi@grimberg.me" <sagi@grimberg.me>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-01-27 at 10:06 +0000, Augusto Mecking Caringi wrote:
> On Thu, Jan 26, 2017 at 3:11 PM, Bart Van Assche
> <Bart.VanAssche@sandisk.com> wrote:
> > This patch is wrong. The purpose of the dev_loss_tmo >=3D LONG_MAX / HZ=
 check
> > is to avoid that the expression 1UL * dev_loss_tmo * HZ further down
> > overflows. Can you check whether changing the if-statement into if (1UL=
 *
> > dev_loss_tmo >=3D LONG_MAX / HZ) also suppresses the compiler warning?
>=20
> Hi Bart,
>=20
>     Right, now a I see...
>=20
>     Doing your proposed change the warning go away...
>=20
>     Do you want me to send a new patch for that?

Hello Augusto,

If you want your patch to go upstream you will have to repost it.

Bart.=
