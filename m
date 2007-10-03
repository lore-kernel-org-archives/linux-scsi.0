From: Jeff Garzik <jeff@garzik.org>
Subject: Re: generating a Linux WWN?
Date: Wed, 03 Oct 2007 01:45:11 -0400
Message-ID: <47032C67.8080109@garzik.org>
References: <50432.44268.qm@web31802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:35127 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbXJCFpP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 01:45:15 -0400
In-Reply-To: <50432.44268.qm@web31802.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Michael Reed <mdr@sgi.com>, James.Smart@Emulex.Com, linux-scsi <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> --- Jeff Garzik <jeff@garzik.org> wrote:
>> The admin will have the option to auto-generate a WWN, should they so 
>> desire.

> What does that mean?  "auto-generate"?  By whom?

The admin tells the kernel module to auto-generate a WWN, and the kernel 
module happily obliges.

The generation algorithm is whatever makes people happy.  I would 
probably pick a fixed prefix like 0x6C 0x69 0x63 ("lin"), something that 
doesn't conflict with IEEE org ids for a long time to come.  Then, 
get_random_bytes() or hash some useful machine characteristics for the 
rest of the bytes.


> What if they don't "auto-generate" (whatever that means)?

Well, you either have a WWN or you don't :)

	Jeff



