From: boutcher@cs.umn.edu (Dave C Boutcher)
Subject: [PATCH] ibmvscsi: convert the ibmvscsi driver to use
 include/scsi/srp.h
Date: Mon, 10 Apr 2006 21:30:57 -0500
Message-ID: <17467.5345.378131.228965@hound.rchland.ibm.com>
References: <20060326035714H.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.33.102]:25814 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S932258AbWDKCbP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Apr 2006 22:31:15 -0400
In-Reply-To: <20060326035714H.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: boutcher@cs.umn.edu, rdreier@cisco.com, linux-scsi@vger.kernel.org


On Sun, 26 Mar 2006 03:57:14 +0900, FUJITA Tomonori <tomof@acm.org> said:
> 
> Dave, can you take a look at this please?
> Seems to work though it has not been tested heavily.
> 
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

I don't want you to think I'm ignoring this...I was out of the country
for a week and now its taking me way longer than it should to set up
an AIX VIO target to test against....tomorrow hopefully.

Thanks a lot for doing this merge.

Dave B
