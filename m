From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Sat, 11 Aug 2018 08:06:10 -0700
Message-ID: <2089960838bccf80f6fb9cc586b1a663f1f9e9da.camel@perches.com>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
         <9b5b906f42dfab78f382c90f66851717d258a15d.camel@perches.com>
         <nycvar.YSQ.7.76.1808101601110.13885@knanqh.ubzr>
         <b3c86ddd67a73c09e09f3e51d7fc70036f00fb7b.camel@perches.com>
         <75d66dfa-688b-f941-04fd-5a39cf882b21@interlog.com>
         <8e63583eb6898c3f481f1cb45b067234737a11b4.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8e63583eb6898c3f481f1cb45b067234737a11b4.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com, Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Jeff Lien <jeff.lien@wdc.com>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, herbert@gondor.apana.org.au, tim.c.chen@linux.intel.com, martin.petersen@oracle.com, david.darrington@wdc.com, jeff.furlong@wdc.com
List-Id: linux-scsi@vger.kernel.org

On Sat, 2018-08-11 at 02:04 -0700, Joe Perches wrote:
> On Fri, 2018-08-10 at 22:39 -0400, Douglas Gilbert wrote:
> > but below is a copy and paste of a table 27 from draft SBC-4
> > revision 15 in chapter 4.22.4.4 on page 87.
> 
> The posted code returns the proper crc for each
> CONFIG_CRYPTO_CRCT10DIF_TABLE_SIZE value from
> 1 to 5 for these arrays.

Jeff, could you please test the suggested patch
with your comparison framework again with each
CONFIG_CRYPTO_CRCT10DIF_TABLE_SIZE from 1 to 5?

I get on a very limited test framework here:
(runtime average of 10 runs)

1: 4.32
2: 1.86
3: 1.31
4: 1.05
5: 0.99
