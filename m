From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Sun, 07 Dec 2008 13:32:37 +0300
Message-ID: <493BA645.80907@ru.mvista.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>	<200812070040.49377.bzolnier@gmail.com>	<20081206235124.00fe60fc@lxorguk.ukuu.org.uk>	<200812070156.37057.bzolnier@gmail.com> <20081207011417.0b340b42@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20081207011417.0b340b42@lxorguk.ukuu.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?ISO-8859-1?Q?Dan_?= =?ISO-8859-1?Q?No=E9?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

Hello.

Alan Cox wrote:

>>> You could just stop turning the old IDE driver into an experimental
>>>       
>> I find your mail offensive/unfair and I'm not going to discuss things
>> at such level if you're going to continue in this style.
>>     
>
> I think the number of changesets and the amount of change versus the
> amount of new functionality speaks for itself.
>   

   The ID core has suffered from to much negliction, so it indeed needed 
many changes (and when the loocking problems that you kept compalining 
about are finally being dealt with, everybody starts screaming to stop 
changing the old code because IDE is going to die soon (as if we had a 
non SCSI emulting ATA disk driver after 5 years past the libata 
merging). What libata people have been really successful at during this 
time (I don't include the SATA work here) is brainwashing everybody 
(even in the non carrier grade embedded sector) that libata is good for 
just about everything...
   As for the new features, what features are really lacking (except the 
polled mode)?

> Alan
>   

MBR, Sergei


