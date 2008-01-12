From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 0/3] update bidirectional series to sit on top of sg_table
Date: Fri, 11 Jan 2008 21:09:00 -0600
Message-ID: <1200107340.3286.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42398 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756975AbYALDJI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 22:09:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <Jens.Axboe@oracle.com>

OK, I suppose in the scheme of things, it's my turn to bear some of the
pain.  the SCSI bidirectional series rejects pretty badly with sg_table,
and since sg_table has to go in, I rebased the series on top of it.

Additionally, I tidied up the patches to take advantages of some of the
features of sg_table.  I killed both use_sg and sg_count in favour of
using sg_table.nseg for the count.

Just so you can test all of this to make sure I got it right, you can
pull the patch series from

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-bidi-2.6.git

James


