From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] bsg: fix bsg_register_queue error path
Date: Sat, 21 Jul 2007 10:14:51 +0900
Message-ID: <20070721100706X.tomof@acm.org>
References: <1184968210.3455.66.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:42780 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757518AbXGUBPE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jul 2007 21:15:04 -0400
In-Reply-To: <1184968210.3455.66.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: fujita.tomonori@lab.ntt.co.jp, Jens.Axboe@oracle.com, linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] bsg: fix bsg_register_queue error path
Date: Fri, 20 Jul 2007 16:50:10 -0500

> unfortunately, if IS_ERR(class_dev) is true, that means class_dev isn't
> null and the check in the error leg is pointless ... it's also asking
> for trouble to request unregistration of a device we haven't actually
> created (although it works currently).  Fix by using explicit gotos and
> unregisters.

ACK, thanks.
