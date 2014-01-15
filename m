From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v9 2/4] Documentation: Add documentation for APM X-Gene
 SoC SATA host controller DTS binding
Date: Wed, 15 Jan 2014 13:08:47 -0800
Message-ID: <CAPw-ZTmVYfPLUVmtes3Gn8Z=+gyFtLoZxc-QUdHH7-ePjKAG9A@mail.gmail.com>
References: <1389769910-15505-1-git-send-email-lho@apm.com>
	<20140115111839.GB25824@e106331-lin.cambridge.arm.com>
	<CAPw-ZT=wJVQ2Qw47Ehgu6rJZ4HkpADrGuhZr8Yjf4XA6z+-xbA@mail.gmail.com>
	<5905127.tqJ3nFt5cj@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <5905127.tqJ3nFt5cj@wuerfel>
Sender: linux-ide-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>, "olof@lixom.net" <olof@lixom.net>, "tj@kernel.org" <tj@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "dmilburn@redhat.com" <dmilburn@redhat.com>, "jcm@redhat.com" <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

>>
>> >> +- clocks             : Reference to the clock entry.
>> >> +- phys                       : PHY reference with parameter 0.
>> >
>> > The specific value of the phy-specifier shouldn't matter to this
>> > binding. What should matter is what it logically corresponds to.
>>
>> I not quite following this. Are you suggest that I drop the value 0.
>> In the binding, one needs to specify the mode of operation - 0 is for
>> SATA. Can you explain more?
>
> The SATA device should not care what the argument for the PHY
> device is. You could connect the same device to another PHY
> that has a different set of arguments, which is the whole point
> of abstracting it.
>

I understand what you wrote here. We should not have an argument from
the host controller. Then my question is how should the PHY node
indicates that it needs to be configured itself as an SATA PHY?

-Loc
