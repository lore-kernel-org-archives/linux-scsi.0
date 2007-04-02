From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 3/4] [SCSI]stex: fix reset recovery for console device
Date: Mon, 02 Apr 2007 13:27:55 -0500
Message-ID: <1175538475.3680.69.camel@mulgrave.il.steeleye.com>
References: <B70A50D07063384EB9BCE3330D18414F0327EBC5@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60727 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965522AbXDBS16 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 14:27:58 -0400
In-Reply-To: <B70A50D07063384EB9BCE3330D18414F0327EBC5@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, jeff <jeff@garzik.org>, Promise_Linux <Promise_Linux@promise.com>

On Mon, 2007-04-02 at 11:14 -0700, Ed Lin wrote:
> I just saw the routine name scsi_eh_try_stu, and didn't notice the
> allow_restart (partly because I thought it was not harmful...).
> But the TEST_UNIT_READY must stay.

Sure ... I was just checking since your change log implied you'd seen
the problem from the error handler ... however, we can add it ...
there's a possibility of getting spin up on init from sd anyway.

James


