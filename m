From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Thu, 22 Jan 2004 14:02:48 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040122140248.C11283@infradead.org>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org> <400C3E70.9040702@us.ibm.com> <20040120133858.A15671@infradead.org> <400D5A28.1000301@us.ibm.com> <20040120180151.A18616@infradead.org> <400EE5E6.9080709@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:23049 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264539AbUAVOCu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 09:02:50 -0500
Content-Disposition: inline
In-Reply-To: <400EE5E6.9080709@us.ibm.com>; from brking@us.ibm.com on Wed, Jan 21, 2004 at 02:49:42PM -0600
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Jan 21, 2004 at 02:49:42PM -0600, Brian King wrote:
> How about a flag in the scsi_device struct that an LLD could set in
> slave_configure, which would prevent upper layer drivers from binding
> to it?

I'm not that happy about this.  But the other solutions I could think
of are ven worse.

> Then these devices could be found through the normal scsi scan
> and would have nice sysfs entries and sg devices for them. Not sure what
> we would call the flag... psuedo_device, fake_device?

ghost? hidden?

Could you cook up a patch?
