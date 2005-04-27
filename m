From: Andrew Morton <akpm@osdl.org>
Subject: ultrastor.c
Date: Wed, 27 Apr 2005 01:04:06 -0700
Message-ID: <20050427010406.67670997.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:19103 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261179AbVD0IE3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2005 04:04:29 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id j3R84Rs4010735
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2005 01:04:28 -0700
Received: from bix (shell0.pdx.osdl.net [10.9.0.31])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id j3R84RiB004504
	for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2005 01:04:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Is it just me, or did ultrastor get broken in 2.6.12-rc3?

drivers/scsi/ultrastor.c: In function `ultrastor_abort':
drivers/scsi/ultrastor.c:948: `FAILURE' undeclared (first use in this function)
drivers/scsi/ultrastor.c:948: (Each undeclared identifier is reported only once
drivers/scsi/ultrastor.c:948: for each function it appears in.)

That's `make allmodconfig' on x86.

(FAILURE is not an option!)
