From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 0/2] libata: support SATA devices on SAS HBAs
Date: Tue, 25 Oct 2005 10:08:28 -0400
Message-ID: <435E3C5C.70007@adaptec.com>
References: <4341A91A.3020000@us.ibm.com> <434251E0.9060000@pobox.com>	 <58cb370e0510040322q1cb7a13bjfc6c7875140d20a9@mail.gmail.com> <58cb370e0510041356h780e7a5aifda0c232f677471e@mail.gmail.com> <43443E99.4090008@pobox.com> <435D5D83.1060201@us.ibm.com> <435E2C25.10009@adaptec.com> <435E357D.1020800@us.ibm.com> <435E35D1.4070907@adaptec.com> <435E38CE.9000000@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <435E38CE.9000000@us.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: brking@us.ibm.com
Cc: Jeff Garzik <jgarzik@pobox.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/25/05 09:53, Brian King wrote:
> Unfortunately, no. My primary goal is to have an API I can use
> in the ipr LLDD, which is a RAID adapter which will talk 
> SPI, SAS, and SATA.

Hm, that's very cool.

> I am still trying to get the patches tested
> in my environment, but since there has been some discussion on the
> list about others needing the same function I figured I would share
> what I have with a wider audience.

That's great.  Keep me posted on how it fares in your environment.
I'll also give them a try.

I think that there will be quite a few things that the ipr driver
and the SAS Transport Layer would set in exactly the same way,
like say, the device id, DMA (rate), etc.  Those commonalities can be
abstracted away later I guess.

If you have a patch introducing this patch to ipr, send it to me please.

Thanks,
	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
