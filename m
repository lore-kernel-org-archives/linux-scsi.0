From: boutcher@cs.umn.edu (Dave C Boutcher)
Subject: Re: [PATCH] ibmvscsi: convert the ibmvscsi driver to use
 include/scsi/srp.h
Date: Thu, 13 Apr 2006 19:24:36 -0500
Message-ID: <17470.60356.84136.133609@hound.rchland.ibm.com>
References: <20060326035714H.tomof@acm.org>
	<adaek0qfieb.fsf@cisco.com>
	<20060326101910L.fujita.tomonori@lab.ntt.co.jp>
	<20060407191016C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.35.202]:13976 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S965033AbWDNAZF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 20:25:05 -0400
In-Reply-To: <20060407191016C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: rdreier@cisco.com, boutcher@cs.umn.edu, linux-scsi@vger.kernel.org

On Fri, 07 Apr 2006 19:10:16 +0900, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> said:
> 
> From: FUJITA Tomonori <tomof@acm.org>
> Subject: Re: [PATCH] ibmvscsi: convert the ibmvscsi driver to use include/scsi/srp.h
> Date: Sun, 26 Mar 2006 10:19:10 +0900
> 
>> > It seems like you can completely delete drivers/scsi/ibmvscsi/srp.h as
>> > part of this patch, right?
>> 
>> Yes. We can get rid of it.
> 
> This can go into scsi-misc.
> 
> ibmvscsi: remove drivers/scsi/ibmvscsi/srp.h
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Dave Boutcher <sleddog@us.ibm.com>

Dave Boutcher
