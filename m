From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Sun, 07 Dec 2008 03:08:06 +0300
Message-ID: <493B13E6.3010807@ru.mvista.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>	<200812061551.08525.bzolnier@gmail.com>	<20081206120001.3580b9e3@tuna>	<200812062241.35601.bzolnier@gmail.com>	<20081206222423.04aada70@lxorguk.ukuu.org.uk>	<493B022B.3050406@ru.mvista.com>	<20081206230227.07b00e2f@lxorguk.ukuu.org.uk>	<493B0867.5020700@ru.mvista.com> <20081206233235.2a3f1602@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20081206233235.2a3f1602@lxorguk.ukuu.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?ISO-8859-1?Q?Dan_?= =?ISO-8859-1?Q?No=E9?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

Hello.

Alan Cox wrote:

>>> - Full SATA and NCQ aware platform support.
>>>   
>>>       
>>    I don't see how SATA/NCQ support is connected to SCSI.
>>     
>
> Because the chunks of scsi midlayer we inherit (actually nowdays mostly
> block) are the pieces you need anyway to do multiple command queues,
>   

   Er, what does this term mean? Several queues per device or a tagged 
queue?

> error recovery from multiple pending commands, barriers and all the other
> nasty sequencing and recovery stuff.
>   

   So, you're just presenting SCSI emulation as a "lesser evil". But 5 
years seems a long enough term to unbind all that stuff from SCSI.

>> directly into SoC's own GPIO, not an expander) -- which requires the 
>> drivers to call the platform code hooks. :-(
>>     
>
> Embedded system design in my experience primarily consists of shooting
> yourself and the programmer in the foot simultaenously with automatic
> weapons while attempting to save 2 cents/unit
>   

   Some h/w designers and programmers do indeed deserve to be shot. :-D

> Alan
>   

MBR, Sergei


