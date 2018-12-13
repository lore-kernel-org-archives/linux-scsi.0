From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] scsi: ufs: add inline crypto support to UFS HCD
Date: Thu, 13 Dec 2018 12:42:30 -0700
Message-ID: <fb17d794-c682-3261-cbad-94ce4c14eea1@kernel.dk>
References: <20181211095027.GA3316@lvlogina.cadence.com>
 <20181211181647.GC221175@gmail.com>
 <CO2PR07MB2469AD9C0A121EBF94129A11C1A70@CO2PR07MB2469.namprd07.prod.outlook.com>
 <BD7FB879CC136E419544C8E2AE7B9C30227EE5@IN01WEMBXA.internal.synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BD7FB879CC136E419544C8E2AE7B9C30227EE5@IN01WEMBXA.internal.synopsys.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ladvine D Almeida <ladvine.dalmeida@synopsys.com>, Parshuram Raju Thombare <pthombar@cadence.com>, Eric Biggers <ebiggers@kernel.org>
Cc: "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "davem@davemloft.net" <davem@davemloft.net>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alan Douglas <adouglas@cadence.com>, Janek Kotas <jank@cadence.com>, Rafal Ciepiela <rafalc@cadence.com>, AnilKumar
List-Id: linux-scsi@vger.kernel.org

On 12/13/18 12:39 PM, Ladvine D Almeida wrote:
> Suggest to take a look into the article https://lwn.net/Articles/717754
> My real concern is how to achieve it without any modifications to the
> bio.(because key slot information has to finally reach the target block
> device)

Guys, you both need to edit when you reply, wading through 650 lines of
text to get to this...

You obviously can't modify the bio if you don't own it, but you could
clone it and then you have storage in ->bi_private.

-- 
Jens Axboe
