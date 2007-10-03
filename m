From: Jeff Garzik <jeff@garzik.org>
Subject: Re: generating a Linux WWN?
Date: Wed, 03 Oct 2007 00:15:24 -0400
Message-ID: <4703175C.8070000@garzik.org>
References: <460931.21951.qm@web31810.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:37382 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbXJCEP3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 00:15:29 -0400
In-Reply-To: <460931.21951.qm@web31810.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Michael Reed <mdr@sgi.com>, James.Smart@Emulex.Com, linux-scsi <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> --- Jeff Garzik <jeff@garzik.org> wrote:
>> Luben Tuikov wrote:
>>> This still does not justify "let's generate it in the kernel".
>> Once an admin specifies to use an alternate WWN provision, the method 
>> used to obtain that WWN is an implementation detail and irrelevant.
> 
> But you're arguing that the kernel should generate it to "help out"
> SAS drivers with HW that has had it's MS/NVRAM erased or corrupted.
> 
> The kernel has no business generating SAS WWN.

Perhaps you missed the English text "once an admin specifies" in the 
quoted email.

	Jeff



