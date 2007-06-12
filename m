From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI
 controllers.
Date: Mon, 11 Jun 2007 18:16:25 -0700
Message-ID: <466DF3E9.30303@linux.intel.com>
References: <20070611184146.448266229@intel.com> <20070611114839.907bcae2.kristen.c.accardi@intel.com> <20070612011148.GA9808@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070612011148.GA9808@khazad-dum.debian.net>
Sender: linux-ide-owner@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jeff@garzik.org, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com
List-Id: linux-scsi@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Mon, 11 Jun 2007, Kristen Carlson Accardi wrote:
>> Setting		Effect
>> ----------------------------------------------------------
>> min_power	ALPM is enabled, and link set to enter 
>> 		lowest power state (SLUMBER) when idle
>> 		Hot plug not allowed.
>>
>> max_performance	ALPM is disabled, Hot Plug is allowed
>>
>> medium_power	ALPM is enabled, and link set to enter
>> 		second lowest power state (PARTIAL) when
>> 		idle.  Hot plug not allowed.
> 
> Just some food for thought:
> 
> If you split it into a enable/disable (0/1) attribute, and a level attribute

on/off doesn't really make sense if the question is "do you favor 
power or do you favor performance".......
