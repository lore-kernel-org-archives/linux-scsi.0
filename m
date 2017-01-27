From: Augusto Mecking Caringi <augustocaringi@gmail.com>
Subject: Re: [PATCH] scsi: srp_transport: Fix 'always false comparison' in srp_tmo_valid()
Date: Fri, 27 Jan 2017 10:06:53 +0000
Message-ID: <CADFy_4HK9nxcB0xn6_Hw6xVKgJKVuVfkFPTsfQSoe-bJc6gGMw@mail.gmail.com>
References: <1485429447-19103-1-git-send-email-augustocaringi@gmail.com> <1485443483.2980.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1485443483.2980.1.camel@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "emilne@redhat.com" <emilne@redhat.com>, "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "sagi@grimberg.me" <sagi@grimberg.me>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 26, 2017 at 3:11 PM, Bart Van Assche
<Bart.VanAssche@sandisk.com> wrote:
> This patch is wrong. The purpose of the dev_loss_tmo >= LONG_MAX / HZ check
> is to avoid that the expression 1UL * dev_loss_tmo * HZ further down
> overflows. Can you check whether changing the if-statement into if (1UL *
> dev_loss_tmo >= LONG_MAX / HZ) also suppresses the compiler warning?

Hi Bart,

    Right, now a I see...

    Doing your proposed change the warning go away...

    Do you want me to send a new patch for that?

-- 
Augusto Mecking Caringi
