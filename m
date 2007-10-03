From: Jeff Garzik <jeff@garzik.org>
Subject: Re: generating a Linux WWN?
Date: Wed, 03 Oct 2007 01:47:06 -0400
Message-ID: <47032CDA.1020303@garzik.org>
References: <660594.90733.qm@web31808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:35144 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbXJCFrL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 01:47:11 -0400
In-Reply-To: <660594.90733.qm@web31808.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Michael Reed <mdr@sgi.com>, James.Smart@Emulex.Com, linux-scsi <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> Do you mean:
>   "The admin will have the option to SPECIFY(SET) a WWN, should they so 
>    desire."
> OR do you mean:
>   "The admin will have the option to HAVE THE KERNEL auto-generate a WWN,
>    should they so desire."

Both.  It is up to admin policy to decide if they wish to use the 
available board's WWN (if present/valid), manually apportion WWNs, or 
whether the kernel's generation algo is fine with them.

	Jeff


