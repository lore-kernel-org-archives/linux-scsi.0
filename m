From: Mark Schaefer <mark@markschaefer.org>
Subject: Booting from or using a Compaq RA4100 Array
Date: Wed, 28 Dec 2005 15:29:51 -0500
Message-ID: <1135801791.9541.12.camel@gateway.markschaefer.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host79.host79-server.com ([66.49.184.32]:59520 "EHLO
	host79.host79-server.com") by vger.kernel.org with ESMTP
	id S964903AbVL1UaC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Dec 2005 15:30:02 -0500
Received: from d14-69-189-243.try.wideopenwest.com (d14-69-189-243.try.wideopenwest.com [69.14.243.189])
	(authenticated bits=0)
	by host79.host79-server.com (8.12.11/8.12.11) with ESMTP id jBSKTp5f031065
	for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2005 15:29:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have a couple of these arrays I purchased from eBay.  Apparently, they
don't work with any other controller card, except cpqfc, which is
unsupported in the 2.6 kernel.  Has anyone gotten these working on a
different card?  If so, is it possible to boot off of this array?  I'm
using Emulex LP8000's, but have the 64-bit/66MHz Compaq cards for
configuration.

	James Bottomley mentioned that it supported the SCC-2 spec, which is
now deprecated, and reading the spec, it seems as though I wouldn't be
able to boot directly from the array.

Thanks in advance for any pointers.  

Mark

