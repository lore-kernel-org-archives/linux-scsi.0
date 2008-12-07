From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Sun, 07 Dec 2008 17:46:57 +0300
Message-ID: <493BE1E1.9020807@ru.mvista.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>	<200812061551.08525.bzolnier@gmail.com>	<20081206120001.3580b9e3@tuna>	<200812062241.35601.bzolnier@gmail.com>	<20081206222423.04aada70@lxorguk.ukuu.org.uk>	<493B022B.3050406@ru.mvista.com>	<20081206230227.07b00e2f@lxorguk.ukuu.org.uk>	<493B0867.5020700@ru.mvista.com>	<20081206233235.2a3f1602@lxorguk.ukuu.org.uk>	<493B13E6.3010807@ru.mvista.com> <20081207114040.24bedc8c@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20081207114040.24bedc8c@lxorguk.ukuu.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?ISO-8859-1?Q?Dan_?= =?ISO-8859-1?Q?No=E9?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

Hello.

Alan Cox wrote:

>>> Because the chunks of scsi midlayer we inherit (actually nowdays mostly
>>> block) are the pieces you need anyway to do multiple command queues,
>>>   
>>>       
>>    Er, what does this term mean? Several queues per device or a tagged 
>> queue?
>>     
>
> Anything beyond issuing one command at a time. The moment you get errors
> with multiple command queues you really need the rest of the block
> supporting logic (small bits of which are still in scsi).
>   

   Something like freezing the queue while error handling is done I guess?

>>    So, you're just presenting SCSI emulation as a "lesser evil". But 5 
>> years seems a long enough term to unbind all that stuff from SCSI.
>>     
>
> It's being done bit by bit. I wasn't aware it was a race, I always
>   

  5 years seems like libata has been running a marathon distance. :-)
   IMHO, you're kind of trying to turn that into a race with constant 
appeals of getting rid of IDE, clearly without enough efforts spent to 
bring about that step so far (looks like there's just not much interest 
in doing that now that all major x86 distributions have adopted libata 
anyway).

> thought that being correct, logical, testable and evolutionary bisectable
> steps was more important somehow.
>   

    I'd question the "evolutionary" and "bisectable" properties of the 
major distributions' decision to switch from IDE to libata. Though I 
guess the state in which IDE code had been at that point contributed to 
that (well, anyway I don't know exactly what was the history beyond the 
stopping of active IDE work)...

> Alan
>   

MBR, Sergei


