From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] exposing the sdev_target in sysfs
Date: 05 Sep 2004 22:05:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094436343.10976.29.camel@mulgrave>
References: <1094254851.1712.28.camel@mulgrave>
	<41394901.3050804@us.ibm.com> <1094306082.1924.0.camel@mulgrave>
	<20040906015836.GX642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:30407 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267396AbUIFCFq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Sep 2004 22:05:46 -0400
In-Reply-To: <20040906015836.GX642@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Mike Christie <mikenc@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-09-05 at 21:58, Matthew Wilcox wrote:
> sequential on a given bus, rather than globally, right?  There's no
> problem with scanning different busses simultanously, is there?

Actually, no, sequential within a given target.  Ensuring this
sequentiality is entirely the province of the scsi subsystem, so as long
as we do the right thing it doesn't matter how parallel we make the bus
scans.

James


