From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 0/3] AHCI Link Power Management
Date: Thu, 14 Jun 2007 16:56:43 +0900
Message-ID: <4670F4BB.3060306@gmail.com>
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com>	<466DFDB5.9030901@gmail.com>	<466E0642.5020506@linux.intel.com>	<466E1D51.9070007@gmail.com>	<20070613090430.GK13747@elf.ucw.cz> <20070613092607.4ddf0f79.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070613092607.4ddf0f79.kristen.c.accardi@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@linux.intel.com>, jeff@garzik.org, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Kristen Carlson Accardi wrote:
>>>>> I'm not sure about this.  We need better PM framework to support 
>>>>> powersaving in other controllers and some ahcis don't save much
>>>>> when only link power management is used,
>>>> do you have data to support this?
>>> Yeah, it was some Lenovo notebook.  Pavel is more familiar with the
>>> hardware.  Pavel, what was the notebook which didn't save much power
>>> with standard SATA power save but needed port to be completely turned off?
>> Thinkpad x60. Some one Kristen probably used while developing the
>> patch :-).
> 
> Yes - that confirms my conclusion that the first patch just wasn't
> done correctly - cause when I measure the power savings with a power
> meter on the X60 with my patches I see ~ 1W.

Hmmm... Could it be that the controller doesn't enter powersave state
when SControl is written to?

-- 
tejun
