From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] bsg: make class backlinks
Date: Sat, 21 Jul 2007 10:14:53 +0900
Message-ID: <20070721100708M.tomof@acm.org>
References: <1184973737.3455.73.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:42779 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577AbXGUBPE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jul 2007 21:15:04 -0400
In-Reply-To: <1184973737.3455.73.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: fujita.tomonori@lab.ntt.co.jp, Jens.Axboe@oracle.com, linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] bsg: make class backlinks
Date: Fri, 20 Jul 2007 18:22:17 -0500

> Currently, bsg doesn't make class backlinks (a process whereby you'd get
> a link to bsg in the device directory in the same way you get one for
> sg).  This is because the bsg device is uninitialised, so the class
> device has nothing it can attach to.  The fix is to make the bsg device
> point to the cdevice of the entity creating the bsg, necessitating
> changing the bsg_register_queue() prototype into a form that takes the
> generic device.

ACK, thanks a lot.
