From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/5] gdth: update deprecated pci_find_device
Date: Thu, 14 Feb 2008 15:55:05 -0500
Message-ID: <47B4AAA9.80805@garzik.org>
References: <47B48CAE.2020705@panasas.com> <47B48DB5.1040303@panasas.com>	 <47B4A0ED.5090401@garzik.org> <1203021914.3158.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33244 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbYBNU4p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Feb 2008 15:56:45 -0500
In-Reply-To: <1203021914.3158.19.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Tobias Oetiker <tobi@oetiker.ch>, allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>, Jon Chelton <jchelton@ffpglobal.com>, Andrew Morton <akpm@linux-foundation.org>, Dave Milter <davemilter@gmail.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2008-02-14 at 15:13 -0500, Jeff Garzik wrote:
>> Boaz Harrosh wrote:
>>> From: Sergio Luis <sergio@larces.uece.br>
>>>
>>> Fix compilation warning in gdth.c, which was using the deprecated
>>> pci_find_device.
> [...]
>> This patch is already upstream...  (unfortunately)
> 
> I think, in spite of the cover name (patches for stable), these are for
> the set of testers who're based on 2.6.24.

Oops!  My mistake, then.

	Jeff



