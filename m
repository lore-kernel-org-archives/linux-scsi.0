From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] ibmvscsi: convert the ibmvscsi driver to use include/scsi/srp.h
Date: Sat, 25 Mar 2006 11:12:28 -0800
Message-ID: <adaek0qfieb.fsf@cisco.com>
References: <20060326035714H.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-4.cisco.com ([171.68.10.86]:42080 "EHLO
	sj-iport-4.cisco.com") by vger.kernel.org with ESMTP
	id S932255AbWCYTMb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Mar 2006 14:12:31 -0500
In-Reply-To: <20060326035714H.tomof@acm.org> (FUJITA Tomonori's message of "Sun, 26 Mar 2006 03:57:14 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: boutcher@cs.umn.edu, linux-scsi@vger.kernel.org

Thanks for doing this work.

It seems like you can completely delete drivers/scsi/ibmvscsi/srp.h as
part of this patch, right?

 - R.
