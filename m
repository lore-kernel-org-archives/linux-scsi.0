From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: About SG Elements of request_buffer
Date: Sun, 15 Oct 2006 10:53:59 -0500
Message-ID: <1160927640.3544.2.camel@mulgrave.il.steeleye.com>
References: <453223AA.50409@aboo.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:22417 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751075AbWJOPyG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Oct 2006 11:54:06 -0400
In-Reply-To: <453223AA.50409@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aboo Valappil <aboo@aboo.org>
Cc: linux-scsi@vger.kernel.org

On Sun, 2006-10-15 at 22:03 +1000, Aboo Valappil wrote:
> 1. Is it safe to assume that all the SG elements of request_buffer are 
> page aligned? (Except the first one and last one),  I mean, it is always 
> multiple of pages?

No.

It's an artifact of block sector size >= PAGE_SIZE and the access method
only using pages.  It isn't even true of ext3 which does its metadata
through the buffer cache.

James


