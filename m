From: boutcher@cs.umn.edu (Dave C Boutcher)
Subject: [PATCH] ibmvscsi: convert the ibmvscsi driver to use
 include/scsi/srp.h
Date: Thu, 13 Apr 2006 19:23:46 -0500
Message-ID: <17470.60306.947519.630317@hound.rchland.ibm.com>
References: <20060326035714H.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.34.202]:11928 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S965033AbWDNAZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 20:25:03 -0400
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

James, I reviewed and tested this exellent merge.  Can you queue
it up?  I'm guessing I hung onto this past the 2.6.17 window.

Acked-by: Dave Boutcher <sleddog@us.ibm.com>

--
Dave Boutcher
