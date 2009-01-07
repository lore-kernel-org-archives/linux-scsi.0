From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: need fusion driver guide
Date: Tue, 06 Jan 2009 22:21:14 -0600
Message-ID: <1231302074.19352.12.camel@localhost.localdomain>
References: <20090106214538.GA18370@uranus.ravnborg.org>
	 <1231278625.10475.28.camel@localhost.localdomain>
	 <e7b7bf130901062002ke59c0dkd7ca0ed73352066f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36347 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923AbZAGEVS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 23:21:18 -0500
In-Reply-To: <e7b7bf130901062002ke59c0dkd7ca0ed73352066f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux linux <linux.tina@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

You still need to turn off html email attachments, otherwise your
messages won't be accepted by the mailing lists.  It will be an option
like recipient wants text/plain only or something.

On Wed, 2009-01-07 at 09:32 +0530, linux linux wrote:
> Hi,
> 
> Sam many thanks for ur help.
> 
> Hi James,
> 
> I am getting some error on for fusion device driver.
> The error message look like this
> 
> 
>        2F240F4C226078: 19/12/2008 EST 04:42:45, mptscsih: ioc1: >>
> Attempting task abort! (sc=e40df080)
>        2F240F6E8C2E00: 19/12/2008 EST 04:42:45, mptbase: ioc1:
> IOCStatus(0x0048): SCSI Task Terminated
>        2F240F6E905A98: 19/12/2008 EST 04:42:45, mptscsih: ioc1: >>
> Attempting task abort! (sc=f7e23680)
> 
> 2F24117BDA2438: 19/12/2008 EST 04:42:50, mptscsih: ioc1: >>
> Attempting bus reset! (sc=e40df080)
> 
> After then the server has been rebooted.
> 
> I can see the code is written inside /drivers/message/fussion/
> mptscsih.c
> The responsible function is
> mptscsih_host_reset()
> i am very new in SCSI fusion device driver. read some help guide from
> google but still i do not understand when the mptscsih_host_reset() is
> called by kernel. I normal situation i am not able to see this message
> in kernel log.
> Can any one help me to understand when these type of kernel message
> are comming, is it foe SCSI hardware problem ?
> when mptscsih_host_reset() will be executed?

It looks like a standard error handling escalation sequence.  Why is
very hard to tell without the entire kernel log.  Why there wasn't a
recovery is also not clear.

> Only one time i show this message in my kernel log, is there any way
> to reproduce this message manually?
> 
> where i get much info regarding this issue and SCSI fusion kernel
> driver except kernel code itself?
> 
> I am writting this after reading help doc from
> http://www.lsi.com/insight_center/tech_trends/advanced_architectures/fusionmpt/index.html
> 
> But still i am very few knowledge to solve it.
> 
> waiting for your help.

There's not much else I can do.  If you post the entire kernel log, the
fusion people hang out on this list and might see something that
indicates what the problem is.

James


