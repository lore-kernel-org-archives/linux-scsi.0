From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Sun, 07 Dec 2008 12:59:11 +0300
Message-ID: <493B9E6F.9080100@ru.mvista.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>	<200812061551.08525.bzolnier@gmail.com>	<20081206120001.3580b9e3@tuna>	<200812062241.35601.bzolnier@gmail.com>	<20081206222423.04aada70@lxorguk.ukuu.org.uk>	<493B022B.3050406@ru.mvista.com> <20081206230227.07b00e2f@lxorguk.ukuu.org.uk> <493B1677.5090705@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <493B1677.5090705@ru.mvista.com>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?ISO-8859-1?Q?Dan_?= =?ISO-8859-1?Q?No=E9?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

Hello, I wrote:

>   Actually, embedded world is much more diverse in its IDE 
> implementations/requirements (you can still encounter a full fledged 
> UltraDMA/133 PATA contoller embedded within a modern SoC), even to the 
> point of complete perversions. I know of a flash device which claims 
> to be IDE compatible (and is indeed registrer level compatible) but 
> only supports certain standard commands, but implements internal 
> paritioning scheme with reads/writes done by vendor specific commands 
> (not even using the standard IDE command execution protocol, IIRC :-).

   Er, no. Judging on the patch that I had to review last year, the 
command protocol is also compatible, so it could've been "riding" on the 
IDE core, just like ide-disk.c (probably libata as well). Instead it's 
driven by a huge out of tree driver (size of a mammoth) -- not sure 
why... :-)
>> Alan 

MBR, Sergei


