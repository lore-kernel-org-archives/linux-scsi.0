From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch 14/25] SCSI: use irq_handler_t where appropriate
Date: Fri, 25 May 2007 11:32:00 +0200
Message-ID: <4656AD10.3000805@s5r6.in-berlin.de>
References: <200705232141.l4NLfjq9001203@shell0.pdx.osdl.net>	 <4654BB27.6050706@garzik.org>	 <1179960902.5569.48.camel@mulgrave.il.steeleye.com>	 <465527D7.6030909@garzik.org>	 <1180015447.3692.6.camel@mulgrave.il.steeleye.com>	 <20070524081720.5675ad5d.randy.dunlap@oracle.com> <1180020539.3692.30.camel@mulgrave.il.steeleye.com> <4655FA62.7080406@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:37203 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbXEYJcC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 May 2007 05:32:02 -0400
In-Reply-To: <4655FA62.7080406@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

Jeff Garzik wrote:
> James Bottomley wrote:
>> SCSI is a slightly different subsystem from almost any other in the
>> kernel.  It has something like 15 active driver maintainers plus at
>> least another 15-25 periodically active ones.  Most (but not all) driver
>> maintainers are employed by the company who produces the board/chip and
>> tend to be overloaded with a lot of non-linux work.

(People who do maintenance on a volunteer basis in spare time tend to be
overloaded with a lot of non-Linux work too.)

>> Requiring acks for
>> maintained drivers is a courtesy to make sure we don't get maintainers
>> spending time trying to resolve conflicts.  I'm not mandating any
>> particular method of getting acks, just noting that cc'ing maintainers
>> and having specific subject lines mentioning the driver is a reasonable
>> way of getting them to notice.
> 
> Linux has never worked that way.  We always have a stream of patches 
> that are multi-subsystem cleanups and the like.  Blocking these patches 
> for months at a time because individual driver maintainers are off doing 
> non-Linux work is just not realistic.

I agree.  Merge conflicts and similar issues with such cleanup patches
or API conversions and the like are issues which driver maintainers and
even subsystem maintainers just have to cope with.  Of course it's a
different matter with patches which change functionality.

The time spent to resolve conflicts
   - can pay off if overall time to handle patch flow is reduced,
   - can be minimized by trying to react quickly on simpler patches.
-- 
Stefan Richter
-=====-=-=== -=-= ==--=
http://arcgraph.de/sr/
