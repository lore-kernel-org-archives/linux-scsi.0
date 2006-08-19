From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] limit recursion when flushing shost->starved_list
Date: Sat, 19 Aug 2006 13:30:29 -0700
Message-ID: <1156019429.3726.18.camel@mulgrave.il.steeleye.com>
References: <20060809153116.GA14043@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:33759 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751558AbWHSWIo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Aug 2006 18:08:44 -0400
In-Reply-To: <20060809153116.GA14043@lion28.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <aherrman@de.ibm.com>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <jejb@SteelEye.com>, Linux SCSI <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, 2006-08-09 at 17:31 +0200, Andreas Herrmann wrote:
> Attached is a patch that should limit a possible recursion that can
> lead to a stack overflow like follows:

Well, OK, initially I'll put this in scsi-misc, since I acknowledge its
a problem.   However, it is one that block queue grouping should be able
to get us out of ... and at that time, this code (and most of the
starved list handling) should exit the scsi mid-layer.

James


