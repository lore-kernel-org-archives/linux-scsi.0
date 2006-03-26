From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] ibmvscsi: convert the ibmvscsi driver to use
 include/scsi/srp.h
Date: Sun, 26 Mar 2006 10:19:10 +0900
Message-ID: <20060326101910L.fujita.tomonori@lab.ntt.co.jp>
References: <20060326035714H.tomof@acm.org>
	<adaek0qfieb.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:20435 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1751245AbWCZBTP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Mar 2006 20:19:15 -0500
In-Reply-To: <adaek0qfieb.fsf@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rdreier@cisco.com
Cc: boutcher@cs.umn.edu, linux-scsi@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] ibmvscsi: convert the ibmvscsi driver to use include/scsi/srp.h
Date: Sat, 25 Mar 2006 11:12:28 -0800

> Thanks for doing this work.

No problem. I need this for the target mode driver.


> It seems like you can completely delete drivers/scsi/ibmvscsi/srp.h as
> part of this patch, right?

Yes. We can get rid of it.
