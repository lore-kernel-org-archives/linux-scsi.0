From: Douglas Gilbert <dougg@torque.net>
Subject: Re: aic7xxx 6.2.24 bug report
Date: Sun, 29 Dec 2002 13:30:07 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E0E5E2F.9030403@torque.net>
References: <20021228204505.GC9319@linnie.riede.org> <766648112.1041108533@aslan.scsiguy.com> <20021228222620.GE9319@linnie.riede.org> <834928112.1041114482@aslan.scsiguy.com> <20021228232624.GG9319@linnie.riede.org> <910548112.1041122117@aslan.scsiguy.com> <20021229015759.GI9319@linnie.riede.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org
Cc: linux-scsi@vger.kernel.org

Willem Riede wrote:
> On 2002.12.28 19:35 Justin T. Gibbs wrote:
> 
>>>I'm particularly surprised by the line
>>>
>>>Parameter aic7xxx length must be 1-1 characters
>>>
>>>which hints that the options are not correctly coded?
>>
>>This is due to the shell magic used during initrds.  Did you
>>try quoting this options?
>>
>>options aic7xxx 'aic7xxx=verbose.debug:0x63'
>>
> 
> I have now, without change. I had earlier quoted just "aic7xxx=verbose.debug:0x63"
> and tried only aic7xxx=verbose to avoid special characters, all with the same
> effect.
> 
> One thought just occured to me, the modutils have been in flux, I'll see if
> there is a newer version than I'm using now.

This seems to be the latest module-init-tools:
http://www.[COUNTRY].kernel.org/pub/linux/kernel/people/rusty/modules/module-init-tools-0.9.6.tar.gz

Announced in lkml:
http://marc.theaimsgroup.com/?l=linux-kernel&m=104089668930417&w=2

BTW Module parameters seem to start working again in lk 2.5.52
(with module-init-tools-0.9.3).

Doug Gilbert


