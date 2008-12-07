From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] remove ide-scsi
Date: Sat, 06 Dec 2008 23:17:22 -0500
Message-ID: <493B4E52.6080905@garzik.org>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>	 <200812061551.08525.bzolnier@gmail.com> <20081206120001.3580b9e3@tuna>	 <200812062241.35601.bzolnier@gmail.com>	 <20081206222423.04aada70@lxorguk.ukuu.org.uk>	 <493B022B.3050406@ru.mvista.com> <493B0A8E.7000506@garzik.org>	 <493B0DF2.4090901@ru.mvista.com> <493B0F36.6030509@garzik.org> <86802c440812061936v4629857ehbd2705e389e4378b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <86802c440812061936v4629857ehbd2705e389e4378b@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?ISO-8859-1?Q?Dan_No=E9?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

Yinghai Lu wrote:
> On Sat, Dec 6, 2008 at 3:48 PM, Jeff Garzik <jeff@garzik.org> wrote:
> 
>> A key reason why, years ago, libata used SCSI as a framework was its utility
>> as a generic driver framework.
>>
>> Therefore, it is an obvious requirement that the non-SCSI "driver framework"
>> code that libata uses must be reimplemented -- in block layer or libata --
>> in order to export an ATA disk as a pure block device.
>>
>> The latest step towards that goal occurred quite recently:  block layer
>> timeouts.
> 
> interesting, so will get /dev/ada instead of /dev/sda?

That is an interesting question.  The easiest thing is to allocate a new 
32-bit block major.  But the more compatible (and more controversial) 
solution is to allocate from the SCSI disk blkmajor space.


> anyone one is building block layer for USB disk? will get /dev/uda?

That already exists -- drivers/block/ub   :)

	Jeff



