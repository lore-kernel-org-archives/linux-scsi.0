From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix sym2 negotiation
Date: 25 Aug 2004 09:23:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093440188.2050.2.camel@mulgrave>
References: <1093113450.1732.334.camel@mulgrave>
	<20040824132936.GA25263@suse.de> <20040824203914.GA25755@us.ibm.com>
	<20040824205126.GA10105@suse.de> <20040825065747.GA2275@us.ibm.com>
	<20040825092541.GA15466@suse.de>
	<20040825115819.GE16196@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:1200 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267368AbUHYNXN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 09:23:13 -0400
In-Reply-To: <20040825115819.GE16196@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Olaf Hering <olh@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Anton Blanchard <anton@samba.org>

On Wed, 2004-08-25 at 07:58, Matthew Wilcox wrote:
> How about hacking the ppc64 bootloader to always pass inq_timeout=30 instead?

This was indeed the solution I thought we agreed to last time.

James


