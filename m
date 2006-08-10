From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH ver3 3/4] qla4xxx: use dev_xxx on some pci/dma resource
	alloc warning and error printks
Date: Thu, 10 Aug 2006 08:59:48 -0500
Message-ID: <1155218388.3670.2.camel@mulgrave.il.steeleye.com>
References: <20060805225156.9557.99072.stgit@bebe.enoyolf.org>
	 <20060805225227.9557.30796.stgit@bebe.enoyolf.org>
	 <20060809230550.480743@bebe.enoyolf.org> <44DB01F2.9000101@cs.wisc.edu>
	 <44DB07F2.9060704@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:13243 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161287AbWHJOCR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Aug 2006 10:02:17 -0400
In-Reply-To: <44DB07F2.9060704@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Doug Maxey <dwm@enoyolf.org>, Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

On Thu, 2006-08-10 at 06:18 -0400, Mike Christie wrote:
> And maybe we need a shost_printk to go along with the sdev and starget
> printks, so drivers do not end up printing different prefixes for the
> same objects like is happening with qla4xxx.

Sure ... add it if you need it.

James


