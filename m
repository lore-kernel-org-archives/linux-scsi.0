From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] we added changes in fnic driver patch 1.6.0.16 to
 acquire io_req_lock in fnic_queuecommand() before issuing I/O so that io
 completion is serialized. But when releasing the lock we check for the I/O
 flags and this could be modified if IO abort occurs before I/O completion.
 In this case we wont release the lock and causes deadlock in some scenerios.
 Using the local variable to check the IO lock status will resolve the
 problem.
Date: Fri, 3 Jul 2015 08:21:35 -0700
Message-ID: <20150703152135.GA4238@infradead.org>
References: <1435872835-30656-1-git-send-email-hishah@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56235 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbbGCPVg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2015 11:21:36 -0400
Content-Disposition: inline
In-Reply-To: <1435872835-30656-1-git-send-email-hishah@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hiral Shah <hishah@cisco.com>
Cc: linux-scsi@vger.kernel.org, Sesidhar Baddela <sebaddel@cisco.com>, Anil Chintalapati <achintal@cisco.com>

Please use a descriptive one line Subject line and put the rest of
your changelog into the message body.

