From: Tejun Heo <htejun@gmail.com>
Subject: Re: [git patches] libata update
Date: Fri, 26 Oct 2007 12:02:34 +0900
Message-ID: <472158CA.1090600@gmail.com>
References: <20071012194002.GA1545@havoc.gtf.org> <20071013070535.D339CA364AB@smtp01.mtu.ru> <4710A420.9000108@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4710A420.9000108@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Andrey Borzenkov wrote:
>> Jeff Garzik wrote:
>>
>>> * Asynchronous notification -- finally userspace CD-ROM polling can go
>>> away!
>>>   (NOTE: waiting on James B to apply the piece that actually makes this
>>>   work...)
>>
>> Does it depend on hardware offering suitable support? What are chances
>> for
>> it to work on 5 years old DVD-ROM?
> 
> Correct -- it requires a new SATA CD-ROM with the AN capability.

And some SATA CD-ROMs lie about AN capability and sends nothing when
media event occurs.  Do we need to start a blacklist or whitelist?  :-)

-- 
tejun
