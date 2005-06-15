From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/1] ipr: Fix for adapter shutdown issue
Date: Wed, 15 Jun 2005 11:14:15 -0500
Message-ID: <42B053D7.70509@us.ibm.com>
References: <200506151515.j5FFFNQA020480@d01av01.pok.ibm.com> <20050615151742.GA24061@infradead.org> <20050615160147.GA27966@suse.de>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39840 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261208AbVFOQOR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 12:14:17 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j5FGEHjW022296
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2005 12:14:17 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j5FGEHwU260976
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2005 12:14:17 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j5FGEG7d004640
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2005 12:14:17 -0400
In-Reply-To: <20050615160147.GA27966@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, haren@us.ibm.com

Greg KH wrote:
> On Wed, Jun 15, 2005 at 04:17:42PM +0100, Christoph Hellwig wrote:
> 
>>On Wed, Jun 15, 2005 at 10:15:22AM -0500, brking@us.ibm.com wrote:
>>
>>>
>>>James,
>>>Haren found this in some recent kexec testing. Without this fix, the
>>>ipr adapter's write cache never gets flushed. I'd like to see this
>>>pushed into 2.6.12 if possible.
>>
>>Umm, there's tons of other drivers doing this. Greg, please revert
>>your pci-layer ->shutdown thing for 2.6.12 and make convert all drivers
>>when re-introducing it.  Or even better make sure it doesn't break
>>drivers setting ->shutdown themselves.
> 
> 
> I'm sorry, what pci-layer ->shutdown thing?  Have a pointer to the patch
> in question that people are having problems with?

This is the one:

http://marc.theaimsgroup.com/?l=linux-pci&m=111751146113738&w=2



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
