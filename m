From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Tue, 20 Jan 2004 09:18:51 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040120171851.GB1628@beaverton.ibm.com>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org> <400C3E70.9040702@us.ibm.com> <20040120133858.A15671@infradead.org> <400D5A28.1000301@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:21237 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S265634AbUATRP2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 12:15:28 -0500
Content-Disposition: inline
In-Reply-To: <400D5A28.1000301@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Brian King [brking@us.ibm.com] wrote:
> >>>this should be handled by the midlayer per-device and per-host state 
> >>>bits.
> >>
> >>I didn't realize a LLD was allowed to modify these.
> >
> >Not directly.  But we have function to e.g. set a device offline.
> 
> Not in 2.6.1. I think this was in, then removed at some point. Anyone 
> know the story on why it was removed? Should we have a 
> scsi_set_host_offline as well?

We removed the interface through the interations of the state model for
scsi_device / scsi_host. We where also overloading the online flag. If
we are going to have LLDDs modify state we may want to close on issues
of using test_bit or not and the locking around these functions.

-andmike
--
Michael Anderson
andmike@us.ibm.com

