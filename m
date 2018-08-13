From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Mon, 13 Aug 2018 13:50:50 +0000
Message-ID: <73795193e598470188953bab268e7af6@AcuMS.aculab.com>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
 <8508c92d70dc41ffb66557e13c988dca@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8508c92d70dc41ffb66557e13c988dca@AcuMS.aculab.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>, 'Jeff Lien' <jeff.lien@wdc.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-crypto@vger.kernel.org'" <linux-crypto@vger.kernel.org>, "'linux-block@vger.kernel.org'" <linux-block@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "'herbert@gondor.apana.org.au'" <herbert@gondor.apana.org.au>, "'tim.c.chen@linux.intel.com'" <tim.c.chen@linux.intel.com>, "'martin.petersen@oracle.com'" <martin.petersen@oracle.com>, "'david.darrington@wdc.com'" <david.darrington@wdc.com>, "'jeff.furlong@wdc.com'" <jeff.furlong@wdc.com>
List-Id: linux-scsi@vger.kernel.org

> A more interesting version would be to generate the lookup table
> for a byte followed by 3 zero bytes.
> You could then run four separate register dependency chains using the
> same 256 entry lookup table.

Not sure that works with a table lookup :-(

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
