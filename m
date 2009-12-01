From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.32-rc8
Date: Tue, 01 Dec 2009 12:15:24 -0500
Message-ID: <yq1vdgqzkcz.fsf@sermon.lab.mkp.net>
References: <1259620194.11762.137.camel@mulgrave.site>
	<20091201080346W.fujita.tomonori@lab.ntt.co.jp>
	<1259676366.11762.239.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:51045 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbZLARQm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2009 12:16:42 -0500
In-Reply-To: <1259676366.11762.239.camel@mulgrave.site> (James Bottomley's
	message of "Tue, 01 Dec 2009 09:06:06 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kai Makisara <Kai.Makisara@kolumbus.fi>


If we are doing another small batch of SCSI fixes before .32 I'd like to
see Mike Christie's error handling fix go in as well.  I just noticed it
ended up being queued in scsi-misc and not scsi-rc-fixes.  It really is
an important bug fix. ad63082626f99651d261ccd8698ce4e997362f7e

-- 
Martin K. Petersen	Oracle Linux Engineering
