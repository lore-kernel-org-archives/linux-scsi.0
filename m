From: David Brownell <david-b@pacbell.net>
Subject: Re: Usb storage mounting was broken somewhere between 2.6.0-test5-bk10
 and 2.6.0-test6-bk1
Date: Tue, 21 Oct 2003 19:25:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F95EA83.50703@pacbell.net>
References: <1066775616.3458.8.camel@m70.net81-64-235.noos.fr> <20031021175556.A8670@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta4.rcsntx.swbell.net ([151.164.30.28]:61681 "EHLO
	mta4.rcsntx.swbell.net") by vger.kernel.org with ESMTP
	id S263345AbTJVCTv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2003 22:19:51 -0400
In-Reply-To: <20031021175556.A8670@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>, Nicolas Mailhot <Nicolas.Mailhot@laPoste.net>
Cc: linux-scsi@vger.kernel.org

That is, http://bugme.osdl.org/show_bug.cgi?id=1310

I've been waiting for the followup from Nicolas:  dmesg logs,
with CONFIG_USB_DEBUG, showing this failure on a current kernel.
(And likely also usb-storage VERBOSE debug...)

If I don't see such information soon, I'll just reject that bug
for insufficient data; it's been missing for nearly two weeks,
clearly this bug was mis-prioritized.


Patrick Mansfield wrote:
> In the bug, Matthew says:
> 
> 	looks like someone may have broken usb_reset_configuration or some
> 	other code path outside of usb-storage.

I couldn't find any evidence of such a thing though.
If it existed, it never made it into bugtraq.


>>I've just retested with 2.6.0-test8-bk1 and the bug is still there.
>>
>>More patch tests, logs, etc available on demand (though the bugzilla
>>entry is already pretty complete)

The bugzilla entry is actually pretty useless.   Where's the
"scenario" data showing there even _is_ a failure case?
(Leaving aside "how/why does it happen"...)


> David - as replied to you by Nicolas in the bug, the dmesg you commented
> on is the one that was working (the "2.6.0-test5-bk5 scenario"). SCSI is
> not confused in that case (though I am somewhat confused by the various
> dmesg and log files).

The convention for bug reports is to describe the failure mode
in some detail.  What this one has is detail for success modes.
The logical conclusion is that there is no bug ...

- Dave



