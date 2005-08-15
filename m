From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] aacraid 2.6: Fix aacraid probe breakage
	inscsi-block-2.6.git
Date: Mon, 15 Aug 2005 12:20:09 -0500
Message-ID: <1124126409.5089.30.camel@mulgrave>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01708AE0@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:27597 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964854AbVHORUT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 13:20:19 -0400
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01708AE0@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2005-08-15 at 13:06 -0400, Salyzyn, Mark wrote:
> The code does not 'damage' the scsi-misc tree version, so why not apply
> it to the scsi-misc tree as well at least to make sure it does not
> (extending the test coverage)? What is the scsi-block timetable for
> downstream?

OK, that's true ... there's no reason not to.

> I have almost religiously applied all patches that touch the driver to
> the Adaptec branch here. The net result is I have caught some gaffs
> early on because we always have some test or Q/A program ready to give
> it coverage.

Yes, early and often ... just in case the scsi-block merge gets delayed
again.

James


