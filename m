From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI/SD: clearer output of disk cache state
Date: Sun, 05 Nov 2006 14:36:56 +0900
Message-ID: <1162705017.3630.36.camel@mulgrave.il.steeleye.com>
References: <472336.19994.qm@web31803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:11231 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161015AbWKEFhC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Nov 2006 00:37:02 -0500
In-Reply-To: <472336.19994.qm@web31803.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2006-11-04 at 16:45 -0800, Luben Tuikov wrote:
> Re-based:

Thanks,

If you want to go the whole hog on this one, we probably also need WCE
and RCD files (taking 1 or 0) for the scsi_disk class and a date in the
feature removal file for dumping the cache_type file.

James




