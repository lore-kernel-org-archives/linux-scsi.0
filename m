From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Thu, 22 Jan 2004 09:27:51 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040122092751.A14990@beaverton.ibm.com>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org> <400C3E70.9040702@us.ibm.com> <20040120133858.A15671@infradead.org> <400D5A28.1000301@us.ibm.com> <20040120180151.A18616@infradead.org> <400EE5E6.9080709@us.ibm.com> <20040122140248.C11283@infradead.org> <20040122083931.A14612@beaverton.ibm.com> <401003B3.8050805@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:24049 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S266334AbUAVR3w
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 12:29:52 -0500
Content-Disposition: inline
In-Reply-To: <401003B3.8050805@us.ibm.com>; from brking@us.ibm.com on Thu, Jan 22, 2004 at 11:09:07AM -0600
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Thu, Jan 22, 2004 at 11:09:07AM -0600, Brian King wrote:

> We will still get errors logged when the partition table is read,
> as the devices are also read protected.

So it is the hardware and not the driver enforcing the read protection?
But other SCSI commands are OK?

-- Patrick Mansfield
