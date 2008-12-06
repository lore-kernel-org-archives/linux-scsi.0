From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] remove ide-scsi
Date: Sat, 06 Dec 2008 18:48:06 -0500
Message-ID: <493B0F36.6030509@garzik.org>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>	<200812061551.08525.bzolnier@gmail.com>	<20081206120001.3580b9e3@tuna>	<200812062241.35601.bzolnier@gmail.com> <20081206222423.04aada70@lxorguk.ukuu.org.uk> <493B022B.3050406@ru.mvista.com> <493B0A8E.7000506@garzik.org> <493B0DF2.4090901@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <493B0DF2.4090901@ru.mvista.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?ISO-8859-1?Q?Dan_No=E9?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

Sergei Shtylyov wrote:
> Hello.
> 
> Jeff Garzik wrote:
> 
>>>>> I think that for the time being it is best to just proceed with the 
>>>>> removal
>>>>> and see if there are any users needing the driver (+ we should 
>>>>> probably try
>>>>> SCSI/libata/osst path first).
>>>>>     
>>>>
>>>> Far better to just leave it there. It generally works for users so all
>>>> you are doing is creating a regression with no possible benefit (other
>>>> than encouraging people to move to libata so we can obsolete all of
>>>> drivers/ide - which is what we really need to do and move the last few
>>>> users over)
>>>>   
>>>
>>>   Oh, yes. SCSI emulation is just what Linux embedded world is asking 
>>> for...
>>
>> The goal is to make SCSI emulation optional for ATA devices, by 
>> creating a libata ATA block device driven by the libata driver framework.
> 
>   Please remind me for how many years this remains a goal?

A long time, yes :)   But clear progress is being made in that 
direction, too.

A key reason why, years ago, libata used SCSI as a framework was its 
utility as a generic driver framework.

Therefore, it is an obvious requirement that the non-SCSI "driver 
framework" code that libata uses must be reimplemented -- in block layer 
or libata -- in order to export an ATA disk as a pure block device.

The latest step towards that goal occurred quite recently:  block layer 
timeouts.

	Jeff


