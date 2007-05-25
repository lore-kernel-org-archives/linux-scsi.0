From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch 14/25] SCSI: use irq_handler_t where appropriate
Date: Fri, 25 May 2007 11:06:19 +0200
Message-ID: <4656A70B.60906@s5r6.in-berlin.de>
References: <200705232141.l4NLfjq9001203@shell0.pdx.osdl.net>	<4654BB27.6050706@garzik.org>	<1179960902.5569.48.camel@mulgrave.il.steeleye.com>	<465527D7.6030909@garzik.org>	<1180015447.3692.6.camel@mulgrave.il.steeleye.com> <20070524081720.5675ad5d.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:37121 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbXEYJGV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 May 2007 05:06:21 -0400
In-Reply-To: <20070524081720.5675ad5d.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

Randy Dunlap wrote:
> On Thu, 24 May 2007 09:04:06 -0500 James Bottomley wrote:
>> maintainers are not always watching everything ... it would be nice if
>> they were, but to give a patch the best shot at review, you try to
>> attract their attention.  Specifically, in this case, you should cc the
>> maintainers and you should have a subject line explaining that you are
>> modifying their driver.  It is very easy to ignore a patch that's simply
>> waved at the SCSI list with a generic subject line.
> 
> I can understand subsystem maintainers ignoring lkml, but ignoring
> the subsystem mailing list makes no sense to me, especially if the
> subject contains "[PATCH]".

I mostly agree.  It becomes difficult with cross-subsystem patches
though.  The difficulty with such patches is that the subsystem
mailinglist which was chosen as adressee doesn't tell the whole picture,
and the subject, even if chosen carefully, often cannot explicitly tell
which places it touches.

On the other hand, submitters of nontrivial cross-subsystem patches can
be expected to put some extra care in their submission, i.e. to add
respective personal addresses.  (And of course to include a diffstat!)

The patch "SCSI: use irq_handler_t where appropriate" is of course not a
patch of this kind.  Also, it is of the sort which IMO doesn't need a
driver maintainer's ACK in the first place.  Sure, it wouldn't have hurt
a lot to call it for example "SCSI: use irq_handler_t in aacraid and
qla2xxx", even though that information will be redundant /after/ it went
into a git tree.
-- 
Stefan Richter
-=====-=-=== -=-= ==--=
http://arcgraph.de/sr/
