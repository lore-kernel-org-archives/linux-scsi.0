From: Jeff Garzik <jeff@garzik.org>
Subject: Re: generating a Linux WWN?
Date: Wed, 03 Oct 2007 12:02:45 -0400
Message-ID: <4703BD25.2010407@garzik.org>
References: <660594.90733.qm@web31808.mail.mud.yahoo.com> <47032CDA.1020303@garzik.org> <4703B62D.3020002@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:49273 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbXJCQCx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 12:02:53 -0400
In-Reply-To: <4703B62D.3020002@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: ltuikov@yahoo.com, James.Smart@Emulex.Com, linux-scsi <linux-scsi@vger.kernel.org>

Michael Reed wrote:
> 
> Jeff Garzik wrote:
>> Luben Tuikov wrote:
>>> Do you mean:
>>>   "The admin will have the option to SPECIFY(SET) a WWN, should they
>>> so    desire."
>>> OR do you mean:
>>>   "The admin will have the option to HAVE THE KERNEL auto-generate a WWN,
>>>    should they so desire."
>> Both.  It is up to admin policy to decide if they wish to use the
>> available board's WWN (if present/valid), manually apportion WWNs, or
>> whether the kernel's generation algo is fine with them.
> 
> Could the reassignment of a board's WWN present any security issues?
> A board which is allowed to access only some targets is now allowed to
> access others.  I would assume that most sites that care about security
> would have other measures in place to guard against this, but it's still
> worth pondering.

Well, at that point the admin has made a conscious decision to deviate 
from the norm, either for site-specific reasons or for 
getting-his-hardware-working reasons.  So we assume the admin who made a 
proactive step in this direction knows what he is doing.

Just like the rest of Linux, we just give you the rope...  :)

	Jeff



