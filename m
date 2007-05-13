From: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Date: Sun, 13 May 2007 18:42:50 +0100
Message-ID: <46474E1A.6080904@simon.arlott.org.uk>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>	 <20070513160608.GA29024@redhat.com>	 <1179072655.3723.42.camel@mulgrave.il.steeleye.com>	 <Pine.LNX.4.64.0705131216440.27468@localhost.localdomain> <1179073670.3723.48.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from proxima.lp0.eu ([85.158.45.36]:34476 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbXEMRm4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 May 2007 13:42:56 -0400
In-Reply-To: <1179073670.3723.48.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On 13/05/07 17:27, James Bottomley wrote:
> On Sun, 2007-05-13 at 12:20 -0400, Robert P. J. Day wrote:
>> since this thread looks like it's going to get away from me in a
>> hurry :-), my only point in asking was to point out that that lone
>> module was the only thing preventing the build from being module-free.
>>
>> i'm not saying that that's *necessarily* a good thing, but it just
>> strikes me as odd that, out of all of the possible modules that might
>> be selected in a default config for x86, this was the *only* one that
>> was picked.
>>
>> i just think it's a bit weird, that's all.
> 
> It's designed on the predicate that people who want to be module free
> will actually set CONFIG_MODULE=n.
> 
> If you set CONFIG_MODULE=y and build SCSI we assume you could have a
> SCSI driver module at some point, which would necessitate the wait scan
> module.

This should be implemented like "Library routines" and only added if such 
a SCSI driver module is actually selected. Why can't it at least be a 
visible option in the menu? (Although even then it looks like it's 
impossible to disable).

Why does ATA select SCSI anyway? Surely PATA doesn't require it?

-- 
Simon Arlott
