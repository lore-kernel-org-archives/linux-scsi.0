From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2.6.16-rc6] Promise SuperTrak driver
Date: Thu, 16 Mar 2006 00:11:08 -0500
Message-ID: <4418F36C.1090508@garzik.org>
References: <NONAMEBSkcJse1fTvOS000001bc@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:48789 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932400AbWCPFLN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Mar 2006 00:11:13 -0500
In-Reply-To: <NONAMEBSkcJse1fTvOS000001bc@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "promise_linux@promise.com" <promise_linux@promise.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Ed Lin wrote:
> I think the tcq is good after reading the related kernel code. But driver
> still need to keep track of the tag for eh and flush. Maybe the driver
> can use find_first_zero_bit(), __set_bit(), and __test_and_clear_bit(),
> because this is what the block layer uses for tag operations.


Once mapped by the block layer, the tag should be accessible via struct
request::tag variable for the lifetime of the struct request.

	Jeff


