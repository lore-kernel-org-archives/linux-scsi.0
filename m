From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] libata: initialize qc->dma_dir to DMA_NONE
Date: Wed, 17 Jan 2007 12:35:06 -0600
Message-ID: <45AE6C5A.3030800@linux.vnet.ibm.com>
References: <45AD50AD.2040700@linux.vnet.ibm.com> <20070116224115.50d29cf7@localhost.localdomain> <45AD55A4.50208@pobox.com> <1168989094.2789.20.camel@mulgrave.il.steeleye.com> <45AD5D27.8020004@linux.vnet.ibm.com> <45AD60B9.3030501@linux.vnet.ibm.com> <20070117023402.GP10987@htj.dyndns.org> <45AD9B7F.4090608@us.ibm.com> <45AD9F1C.2050808@pobox.com> <45AE348F.4050003@linux.vnet.ibm.com>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49118 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564AbXAQSfL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jan 2007 13:35:11 -0500
In-Reply-To: <45AE348F.4050003@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: Jeff Garzik <jgarzik@pobox.com>, Brian King <brking@us.ibm.com>, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Alan <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>

Brian King wrote:
> Jeff Garzik wrote:
>> Brian King wrote:
>>> ACK
>> Does this response mean that you've tested it, and successfully verified
>> your problem is gone?
> 
> Yes, I have tested it, but all my problems are not gone with this
> one patch. This fixes the problem I was seeing where the data direction
> was set incorrectly, but I still have some other issues I am
> working through. I'll be sending out additional patches shortly.

I just sent three small libata patches to linux-ide which fix the problems
I was seeing. I am still running additional tests to make sure there are
not any other issues, but everything looks pretty good so far.

Thanks,

Brian


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
