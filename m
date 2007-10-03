From: Michael Reed <mdr@sgi.com>
Subject: Re: generating a Linux WWN?
Date: Wed, 03 Oct 2007 10:33:01 -0500
Message-ID: <4703B62D.3020002@sgi.com>
References: <660594.90733.qm@web31808.mail.mud.yahoo.com> <47032CDA.1020303@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53592 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751341AbXJCPdE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 11:33:04 -0400
In-Reply-To: <47032CDA.1020303@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: ltuikov@yahoo.com, James.Smart@Emulex.Com, linux-scsi <linux-scsi@vger.kernel.org>



Jeff Garzik wrote:
> Luben Tuikov wrote:
>> Do you mean:
>>   "The admin will have the option to SPECIFY(SET) a WWN, should they
>> so    desire."
>> OR do you mean:
>>   "The admin will have the option to HAVE THE KERNEL auto-generate a WWN,
>>    should they so desire."
> 
> Both.  It is up to admin policy to decide if they wish to use the
> available board's WWN (if present/valid), manually apportion WWNs, or
> whether the kernel's generation algo is fine with them.

Could the reassignment of a board's WWN present any security issues?
A board which is allowed to access only some targets is now allowed to
access others.  I would assume that most sites that care about security
would have other measures in place to guard against this, but it's still
worth pondering.

Mike

> 
>     Jeff
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
