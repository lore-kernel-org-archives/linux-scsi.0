From: Luben Tuikov <tluben@rogers.com>
Subject: Re: Patch: change the serial_number for error-handler commands
Date: Thu, 22 May 2003 01:47:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ECC648E.4030103@rogers.com>
References: <3ECA9D46.7010301@rogers.com> <Pine.LNX.4.44L0.0305202110520.4914-100000@netrider.rowland.org> <20030521180308.GD1116@beaverton.ibm.com> <3ECBD122.3090702@rogers.com> <20030521202809.GA1791@beaverton.ibm.com> <3ECBEB8D.4030008@rogers.com> <20030521161544.A24646@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-mail.bloor.is.net.cable.rogers.com ([66.185.86.72]:24334
	"EHLO fep02-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S262321AbTEVFe4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2003 01:34:56 -0400
In-Reply-To: <20030521161544.A24646@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> 
> My less than $.02:
> 
> As far as the code goes, it does not matter whether we store the current
> or next value in shost->serial_number,

I was _just_ mentioning what is normally done in implementations of some
transports... (but actually they need to store the next, but it seems
we'll not use this ability in SCSI Core, so yes, it doesn't really matter...)

> so we ought to use the simpler code
> (Mike's version).

You mean Eric's version -- this was in SCSI Core _before_ you two
started paid work on SCSI Core.

>  And (x += 2)++ won't compile.

Aaaah, I've mentioned this before several times, which is
my usual disclaimer: the only C code which I send to
linux scsi is in a patch.  Anything else, doesn't matter
how C-like it is, if it is in text, is just that: C-like.

I'm just trying to convey an idea.

Actually I _did_ set up a running verion of this as a patch today
but I never sent it -- too much politics, I got discouraged and
saw absolutely _no_ point.

> Per naming: "get" is already overloaded and implies a put. We have code
> like scsi_get_cmd that allocates and returns a pointer/value, and then
> various scsi and other kernel get/put functions that take a pointer and
> increment or decrement ref counters. cmdsn is a rather cryptic
> abbreviation that my brain can't easily parse.
> 
> I suggest scsi_serial_number(host) or scsi_cmdsn(host).

I personally am getting tired of those
	scsi_this_is_a_long_name_for_a_trivial_function()
function names in scsi so I'd go for the second.

-- 
Luben

