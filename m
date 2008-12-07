From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Sun, 07 Dec 2008 13:41:43 +0300
Message-ID: <493BA867.4070709@ru.mvista.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>	<200812061551.08525.bzolnier@gmail.com>	<20081206120001.3580b9e3@tuna>	<200812062241.35601.bzolnier@gmail.com>	<20081206222423.04aada70@lxorguk.ukuu.org.uk>	<493B022B.3050406@ru.mvista.com> <20081206230227.07b00e2f@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20081206230227.07b00e2f@lxorguk.ukuu.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?ISO-8859-1?Q?Dan_?= =?ISO-8859-1?Q?No=E9?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

Hello.

Alan Cox wrote:

>>    Oh, yes. SCSI emulation is just what Linux embedded world is asking 
>> for...
>>     
>
> Well ATAPI is SCSI emulation (its a sort of pidgin SCSI admittedly).
>
> I'm actually seeing two strands of requests (including from embedded)
>
> - CF only small "dumb as president" type driver that is written to be as
> compact as possible and preferably considers IRQs as optional
> - Full SATA and NCQ aware platform support.
>   

    I think that such diverse requests are coming from the different 
sectors of the embedded market, e.g. consumer electronics and carrier 
grade respectfully (Octeon probably being an exception here) which 
different greatly in the horsepower of the backing CPUs -- with carrier 
grade CPUs being multicore CPUs running at several GHz with a lot of 
memory (and using chipset ATA controllers) and the consumer electronics 
employing mostly RISC CPUs running at 200-300 MHz with not that much 
memory). The only SoC integrated SATA controller I know of in the 
embedded market is produced by Freescale, others continue embedding good 
old PATA controllers (although this is probably going to change given 
much lower pin count needed for SATA).

> Alan
>   

MBR, Sergei


