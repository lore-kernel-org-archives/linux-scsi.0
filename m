From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: linux-next: Tree for Aug 1
Date: Thu, 2 Aug 2018 05:04:00 +0000
Message-ID: <e3e32fd801cb1270cddec6fc1ea3dabad4473b64.camel@wdc.com>
References: <20180801175852.36549130@canb.auug.org.au>
         <20180801224813.GA13074@roeck-us.net>
         <1533163965.3158.1.camel@HansenPartnership.com>
         <20180801234727.GA3762@roeck-us.net>
         <CACVXFVMrzLRP5Q=cwZGnqeUeyODL3Pq9jMkT7czZouK9510fUA@mail.gmail.com>
         <1533168205.3158.12.camel@HansenPartnership.com>
         <171b2cdc-2e74-2b3c-e5f5-c656a196601a@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <171b2cdc-2e74-2b3c-e5f5-c656a196601a@roeck-us.net>
Content-Language: en-US
Content-ID: <54378916F667384BAEA486F5C42A5B28@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux@roeck-us.net" <linux@roeck-us.net>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>
Cc: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2018-08-01 at 21:58 -0700, Guenter Roeck wrote:
+AD4- I am running out of ideas. Any thoughts on how to track this down fur=
ther ?

Is a shell available when the hang occurs? If so, it would be helpful if yo=
u
could provide a dump of the information in /sys/kernel/debug/block. There i=
s
namely detailed information in that directory about pending commands.

Bart.
