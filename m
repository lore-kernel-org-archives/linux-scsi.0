From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: sym2 probs in bk-scsi tree
Date: 08 Apr 2004 11:03:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081440194.1885.259.camel@mulgrave>
References: <20040407231820.66dd76cd.akpm@osdl.org>
	<20040408145700.GB18329@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:44743 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261937AbUDHQD2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2004 12:03:28 -0400
In-Reply-To: <20040408145700.GB18329@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-04-08 at 09:57, Matthew Wilcox wrote:
> They certainly are scary.  What is device 15 on this scsi bus?  This
> looks like domain validation being applied to a device that can't do it
> to me.  Did I get that right, James?

Actually, it might be a driver issue; I'll have to look. I suspect the
SES device probably said it didn't support either wide or sync in its
inquiry return; we went ahead and tried negotiating anyway and it got
confused.

James


