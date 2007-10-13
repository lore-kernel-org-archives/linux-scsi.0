From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git patches] libata update
Date: Sat, 13 Oct 2007 06:55:28 -0400
Message-ID: <4710A420.9000108@garzik.org>
References: <20071012194002.GA1545@havoc.gtf.org> <20071013070535.D339CA364AB@smtp01.mtu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20071013070535.D339CA364AB@smtp01.mtu.ru>
Sender: linux-ide-owner@vger.kernel.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Andrey Borzenkov wrote:
> Jeff Garzik wrote:
> 
>> * Asynchronous notification -- finally userspace CD-ROM polling can go
>> away!
>>   (NOTE: waiting on James B to apply the piece that actually makes this
>>   work...)
> 
> Does it depend on hardware offering suitable support? What are chances for
> it to work on 5 years old DVD-ROM?

Correct -- it requires a new SATA CD-ROM with the AN capability.

	Jeff



