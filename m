From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Large amount of scsi-sgpool objects
Date: Wed, 04 Mar 2009 12:28:46 +0100
Message-ID: <49AE65EE.5020605@s5r6.in-berlin.de>
References: <1236115544.15993.22.camel@localhost.localdomain> <20090303214454.GA8288@elte.hu> <1236119990.24019.35.camel@localhost.localdomain> <20090303230323.GA21644@elte.hu> <49ADBE29.4040706@s5r6.in-berlin.de> <20090303234834.GA13389@elte.hu> <49AE221D.9010909@s5r6.in-berlin.de> <1236150752.6049.19.camel@marge.simson.net> <49AE32B5.9040603@s5r6.in-berlin.de> <alpine.LFD.2.00.0903041004300.29264@localhost.localdomain> <20090304111235.GA14593@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:33349 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbZCDL3x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2009 06:29:53 -0500
In-Reply-To: <20090304111235.GA14593@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Ingo Molnar wrote:
> * Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Wed, 4 Mar 2009, Stefan Richter wrote:
>> > As I said, I recommend that people do not receive those off-topic
>> > patches by default, only on demand.  (Because I sometimes work with -rt
>> > users.)
>> 
>> And as I said before, I missed to remove the patch before pushing out
>> the -rt tree. So I really do not need repeated advise on how to do my
>> work.
> 
> yeah. I dont think Stefan ever maintained a high-volume generic 
> tree before. Kibitzing from the sidelines always makes it seem 
> so easy ;-)

You could also take this "I recommend..." not as advice how to do your
work but rather as a /user request/ regarding the outcome of your work.

(But you know all that already of course; you also know what's best for
those who pull your trees.)
-- 
Stefan Richter
-=====-==--= --== --=--
http://arcgraph.de/sr/
