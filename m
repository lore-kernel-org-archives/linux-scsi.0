From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [patch] aic79xx hostraid support
Date: Mon, 23 Aug 2004 10:02:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4129F8F6.8070902@adaptec.com>
References: <20040821133214.GA28890@devserv.devel.redhat.com> <20040821142245.GA9151@devserv.devel.redhat.com> <4129F4E2.10103@adaptec.com> <20040823135143.GE17268@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:64140 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S264388AbUHWOCe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 10:02:34 -0400
In-Reply-To: <20040823135143.GE17268@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: linux-scsi@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, Aug 23, 2004 at 09:45:06AM -0400, Luben Tuikov wrote:
> 
>>Those patches are from the more recent versions of the AIC drivers,
>>from Justin's website, verbatim but somehow reworked to compile for older
>>versions of the drivers.
>>
>>Please don't claim that you wrote it or as your own work.
> 
> 
> I do not and never have claimed it as my own work.
> 
> Do you agree that this patch is a useful addition for now, until you start
> sending similar small improvements to linux-scsi for the drivers?

Yes, sure, if it works for people _and_ they realize that it is:
a) temporary,
b) taken from the later version of the driver on Justin's website, and
c) it will be scrapped completely since the later versions which I'll
   be sending *contain and absolve* this or any other similar patches.
 
> (I for sure think it would be a bad thing if aic7xxx entirely halted pending
> that)

Yes, I agree.

		Luben


