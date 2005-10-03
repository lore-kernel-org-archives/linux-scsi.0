From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Mon, 03 Oct 2005 11:08:37 -0400
Message-ID: <43414975.5090708@adaptec.com>
References: <Pine.LNX.4.10.10509300015100.27623-100000@master.linux-ide.org> <433D8542.1010601@adaptec.com> <A0262C6F-6B0E-4790-BA42-FAFD6F026E0A@mac.com> <433D8D1F.1030005@adaptec.com> <0F03AA4B-D2D1-4C57-B81B-FC95CB863A98@mac.com> <87f94c370509301510nba59ac2m59f507f70de6e46b@mail.gmail.com> <433DD020.8000906@pobox.com> <20051001045812.GF18716@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:25044 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751037AbVJCPIn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2005 11:08:43 -0400
In-Reply-To: <20051001045812.GF18716@alpha.home.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willy Tarreau <willy@w.ods.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Greg Freemyer <greg.freemyer@gmail.com>, Kyle Moffett <mrmacman_g4@mac.com>, Andre Hedrick <andre@linux-ide.org>, "David S. Miller" <davem@davemloft.net>, patmans@us.ibm.com, ltuikov@yahoo.com, linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On 10/01/05 00:58, Willy Tarreau wrote:
> On Fri, Sep 30, 2005 at 07:54:08PM -0400, Jeff Garzik wrote:
> 
>>Greg Freemyer wrote:
>>
>>>Luben has more than once called for adding a small number of
>>>additional calls to the existing SCSI core.  These calls would
>>>implement the new (reduced) functionallity.  The old calls would
>>>continue to support the full SPI functionallity.  No existing  LLDD
>>>would need modification.
>>
>>IOW, what Luben wants is:
>>
>>	if (Luben)
>>		do this
>>	else
>>		do current stuff
>>
>>If this is the case, why bother touching drivers/scsi/* at all?
> 
> 
> that's the reason why I proposed that this moved to drivers/sas/* or
> somewhere else so that there is no maintaining conflict.

Yes, it has been moved already there.
http://linux.adaptec.com/sas/

	Luben
