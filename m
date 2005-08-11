From: Harald Seipp <SEIPP@de.ibm.com>
Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 18:50:03 +0200
Message-ID: <OFD1AF1EB2.F396BA40-ONC125705A.005C072D-C125705A.005C7944@de.ibm.com>
References: <20050811164003.GB4351@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:32508 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751121AbVHKQyA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 12:54:00 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.12.10/8.12.10) with ESMTP id j7BGrxOA147274
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 16:53:59 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7BGrxo2171226
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 18:53:59 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j7BGrwDA030876
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 18:53:59 +0200
In-Reply-To: <20050811164003.GB4351@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote on 11.08.2005 18:40:03:
> On Thu, Aug 11, 2005 at 05:44:46PM +0200, Harald Seipp wrote:
> > Thank you for your quick responses! It finally looks like the task I
need
> > to do - fully rescan all hosts for newly attached/changed devices -
must
> > include the logic to skip devices with mounted fs for 2.6.
>
> Why do you want to rescan a full bus anyway?  What SCSI transport do you
> want this for?  All transports where new targets can be hot-plugged
should
> be doing automatic scanning already.
Old-fashioned parallel SCSI bus and FC/SAN where there are no hot-plug
events AFAIK. Rescanning is required for device diagnostics. Diagnostic
usage will also demand online device exchange - testing multiple devices,
one after another.

Harald Seipp
IBM Systems and Technology Group


