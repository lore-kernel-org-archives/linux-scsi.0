From: David Brownell <david-b@pacbell.net>
Subject: Re: Usb storage mounting was broken somewhere	between	2.6.0-test5-bk10
 and 2.6.0-test6-bk1
Date: Wed, 22 Oct 2003 09:20:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F96AE64.5020305@pacbell.net>
References: <1066775616.3458.8.camel@m70.net81-64-235.noos.fr>	 <20031021175556.A8670@beaverton.ibm.com>	 <1066808944.3699.9.camel@ulysse.olympe.o2t>  <3F969E04.6060801@pacbell.net> <1066837537.6960.3.camel@ulysse.olympe.o2t>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtaw6.prodigy.net ([64.164.98.56]:50599 "EHLO mtaw6.prodigy.net")
	by vger.kernel.org with ESMTP id S263486AbTJVQPe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 12:15:34 -0400
In-Reply-To: <1066837537.6960.3.camel@ulysse.olympe.o2t>
List-Id: linux-scsi@vger.kernel.org
To: Nicolas Mailhot <Nicolas.Mailhot@laPoste.net>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

Nicolas Mailhot wrote:

>>So I closed that bug report.  If you come up with any
>>evidence to support a real bug report, file a new bug
>>report with it.  But having this one sitting around
>>in such a state does nobody any good.
> 
> 
> Rhaa. There is no evidence of a failure. The reader is plugged like in
> previous kernels, logs show it's detected as a usb-storage device, then
> *nothing*.

Not according to any information you included in the bug report,
after several weeks of waiting for clarifications...

Maybe you thought you'd included that information, but it's
not there.  The only "logs show ..." information you included
was for cases where everything worked (test5).



> I can't give you any error because no error is outputed. If I could make
> up an error message believe me I would .

No, please don't make up error messages.

If you file a new bug report, just include dmesg output
demonstrating the problem you're describing -- on a
current kernel.


