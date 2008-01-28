From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] zfcp: fix sense_buffer access bug
Date: Mon, 28 Jan 2008 11:04:47 +0100
Message-ID: <20080128100446.GA4732@schmichrtp.de.ibm.com>
References: <20080127124124H.tomof@acm.org> <20080128074624.GA4622@schmichrtp.de.ibm.com> <20080128182912W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:6401 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYA1KEu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jan 2008 05:04:50 -0500
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate3.uk.ibm.com (8.13.8/8.13.8) with ESMTP id m0SA4nM7247970
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jan 2008 10:04:49 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0SA4nnN4059214
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jan 2008 10:04:49 GMT
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0SA4jGx021346
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jan 2008 10:04:45 GMT
Content-Disposition: inline
In-Reply-To: <20080128182912W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tomof@acm.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Mon, Jan 28, 2008 at 06:29:12PM +0900, FUJITA Tomonori wrote:
> > ACK for fixing the access to the sense buffer.
> > 
> > We are working internally on cleaning up the zfcp messages. With this
> > change, the 'trace' and 'hex dump' messages will disappear. So, could
> > you simply remove the ZFCP_HEX_DUMP message above, instead of fixing
> > it?
> 
> I can but James has already merged the above patch to scsi-misc. So it
> would be more convenient for everyone if you could rebase your
> patchset on top of scsi-misc?

Ok, if the pach is already merged, i am fine with that. We will have
to rebase the patches we are working on anyway. Thanks for providing
the fix.

Christof
