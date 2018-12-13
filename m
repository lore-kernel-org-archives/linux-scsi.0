From: Ladvine D Almeida <ladvine.dalmeida@synopsys.com>
Subject: Re: [PATCH 2/2] scsi: ufs: add inline crypto support to UFS HCD
Date: Thu, 13 Dec 2018 20:04:54 +0000
Message-ID: <BD7FB879CC136E419544C8E2AE7B9C30227F0B@IN01WEMBXA.internal.synopsys.com>
References: <20181211095027.GA3316@lvlogina.cadence.com>
 <20181211181647.GC221175@gmail.com>
 <CO2PR07MB2469AD9C0A121EBF94129A11C1A70@CO2PR07MB2469.namprd07.prod.outlook.com>
 <BD7FB879CC136E419544C8E2AE7B9C30227EE5@IN01WEMBXA.internal.synopsys.com>
 <fb17d794-c682-3261-cbad-94ce4c14eea1@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Ladvine D Almeida <ladvine.dalmeida@synopsys.com>, Parshuram Raju Thombare <pthombar@cadence.com>, Eric Biggers <ebiggers@kernel.org>
Cc: "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "davem@davemloft.net" <davem@davemloft.net>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alan Douglas <adouglas@cadence.com>, Janek Kotas <jank@cadence.com>, Rafal Ciepiela <rafalc@cadence.com>, AnilKumar
List-Id: linux-scsi@vger.kernel.org

On 13/12/18 7:42 PM, Jens Axboe wrote:=0A=
> On 12/13/18 12:39 PM, Ladvine D Almeida wrote:=0A=
>> Suggest to take a look into the article https://urldefense.proofpoint.co=
m/v2/url?u=3Dhttps-3A__lwn.net_Articles_717754&d=3DDwICaQ&c=3DDPL6_X_6JkXFx=
7AXWqB0tg&r=3Dz00zRD9ARrwHpe-XSl1OtUp1uNKGYoXI1G2DhOaDDBI&m=3D-pGzV3wdSje33=
7vKOYoYB6NgU_DGDmQvfQ9egLDRYNQ&s=3Dc4FXsrwD0BLAjE4UC47R2ngLnx_DP5jiOr0dtZ7t=
Gsw&e=3D=0A=
>> My real concern is how to achieve it without any modifications to the=0A=
>> bio.(because key slot information has to finally reach the target block=
=0A=
>> device)=0A=
> =0A=
> Guys, you both need to edit when you reply, wading through 650 lines of=
=0A=
> text to get to this...=0A=
Jens, Thanks for your reply. I will take care of it next time onwards. :-)=
=0A=
=0A=
> =0A=
> You obviously can't modify the bio if you don't own it, but you could=0A=
> clone it and then you have storage in ->bi_private.=0A=
> =0A=
=0A=
I agree. I can clone the bio in the crypto target and use bi_private.=0A=
But, when i finally submit the bio and it reaches the target block=0A=
device, the information stored in bi_private is lost.=0A=
=0A=
Regards,=0A=
Ladvine=0A=
