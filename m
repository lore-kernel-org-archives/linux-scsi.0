From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Sun, 07 Dec 2008 02:42:42 +0300
Message-ID: <493B0DF2.4090901@ru.mvista.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>	<200812061551.08525.bzolnier@gmail.com>	<20081206120001.3580b9e3@tuna>	<200812062241.35601.bzolnier@gmail.com> <20081206222423.04aada70@lxorguk.ukuu.org.uk> <493B022B.3050406@ru.mvista.com> <493B0A8E.7000506@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <493B0A8E.7000506@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?ISO-8859-1?Q?Dan_No=E9?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

Hello.

Jeff Garzik wrote:

>>>> I think that for the time being it is best to just proceed with the 
>>>> removal
>>>> and see if there are any users needing the driver (+ we should 
>>>> probably try
>>>> SCSI/libata/osst path first).
>>>>     
>>>
>>> Far better to just leave it there. It generally works for users so all
>>> you are doing is creating a regression with no possible benefit (other
>>> than encouraging people to move to libata so we can obsolete all of
>>> drivers/ide - which is what we really need to do and move the last few
>>> users over)
>>>   
>>
>>   Oh, yes. SCSI emulation is just what Linux embedded world is asking 
>> for...
>
> The goal is to make SCSI emulation optional for ATA devices, by 
> creating a libata ATA block device driven by the libata driver framework.

   Please remind me for how many years this remains a goal?

>     Jeff 

MBR, Sergei


