From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] ibmvscsi: convert the ibmvscsi driver to use
 include/scsi/srp.h
Date: Sun, 26 Mar 2006 15:09:45 +0900
Message-ID: <20060326150945S.fujita.tomonori@lab.ntt.co.jp>
References: <20060326035714H.tomof@acm.org>
	<20060326001506.GA29975@krispykreme>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:64739 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1750747AbWCZGKL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Mar 2006 01:10:11 -0500
In-Reply-To: <20060326001506.GA29975@krispykreme>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anton@samba.org
Cc: boutcher@cs.umn.edu, rdreier@cisco.com, linux-scsi@vger.kernel.org

From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] ibmvscsi: convert the ibmvscsi driver to use include/scsi/srp.h
Date: Sun, 26 Mar 2006 11:15:06 +1100

> > Dave, can you take a look at this please?
> > 
> > Seems to work though it has not been tested heavily.
> 
> Cool, survives a dbench run here.

Nice. Thanks for testing.
