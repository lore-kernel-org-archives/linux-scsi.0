From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi_debug: illegal blocking memory allocation
Date: Thu, 04 Jan 2007 09:10:01 -0600
Message-ID: <1167923401.2819.7.camel@mulgrave.il.steeleye.com>
References: <20070103134907.GV11203@kernel.dk> <459C92CE.4090709@torque.net>
	 <20070104112156.GV11203@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:57666 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964870AbXADPK2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jan 2007 10:10:28 -0500
In-Reply-To: <20070104112156.GV11203@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

On Thu, 2007-01-04 at 12:21 +0100, Jens Axboe wrote:
> I guess it's fully up to you how you want to solve it. The scheme seems
> a little elaborate, but these error conditions are unlikely to ever been
> seen in the wild, so no objections from me.

Actually, there's already a DID_ code that does what you want.  Instead
of DID_ERROR, which will retry immediately, there's DID_REQUEUE which
will halt the device queue and wait for a returning command to retry.

James


