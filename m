From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] aic94xx: fix SSP IU status print-out
Date: Tue, 02 Oct 2007 10:35:47 -0400
Message-ID: <47025743.3070100@garzik.org>
References: <20070930140317.GA7134@havoc.gtf.org>	 <4702399A.9010708@garzik.org> <1191334857.3530.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:46880 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbXJBOft (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 10:35:49 -0400
In-Reply-To: <1191334857.3530.39.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Tue, 2007-10-02 at 08:29 -0400, Jeff Garzik wrote:
>> James, what is the upstream status of my two aic94xx bug fixes?
>>
>> Have they been sent to Linus yet?
>>
>> Since you seem M.I.A., I'll send them upstream if I do not hear from you 
>> today.
> 
> They're hardly -rc8 critical bug fixes, since no-one has noticed their
> effects for about 5 kernel releases.  I'll stick them into scsi-misc
> with the rest of the pending stuff.

Except for those people who want SMP to work, on platforms where 
TODEVICE actually matters.

I'll send them upstream myself.


> And going away for the Weekend is hardly MIA.

A week has gone by since any SCSI commit, and longer than that if you 
actually look at the send-date of the most recent patch applied.

	Jeff


