From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi_debug: illegal blocking memory allocation
Date: Thu, 04 Jan 2007 09:34:32 -0600
Message-ID: <1167924872.2819.12.camel@mulgrave.il.steeleye.com>
References: <20070103134907.GV11203@kernel.dk> <459C92CE.4090709@torque.net>
	 <20070104112156.GV11203@kernel.dk>
	 <1167923401.2819.7.camel@mulgrave.il.steeleye.com>
	 <20070104152748.GE24620@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:57888 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964928AbXADPjq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jan 2007 10:39:46 -0500
In-Reply-To: <20070104152748.GE24620@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jens Axboe <jens.axboe@oracle.com>, Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

On Thu, 2007-01-04 at 08:27 -0700, Matthew Wilcox wrote:
> Any returning command, or a returning command from this device? 

This device

>  We may
> be out of memory from a different device, and this may be the only
> command being sent to the scsi_debug driver.  Wouldn't we end up
> halting the device queue indefinitely then?

it's basically the SCSI_MLQUEUE_DEVICE_BUSY condition ... and yes, it
has a mechanism for no outstanding commands.

James


