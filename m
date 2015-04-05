From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/7] scsi: add host template init/exit_command hooks
Date: Sun, 5 Apr 2015 17:40:55 +0200
Message-ID: <20150405154055.GC28173@lst.de>
References: <1428076703-31014-1-git-send-email-axboe@fb.com> <1428076703-31014-6-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45875 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbbDEPk5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Apr 2015 11:40:57 -0400
Content-Disposition: inline
In-Reply-To: <1428076703-31014-6-git-send-email-axboe@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de

On Fri, Apr 03, 2015 at 09:58:21AM -0600, Jens Axboe wrote:
> If a LLD has hardware commands in the request pdu, then we need some
> helper hooks to help the driver initialize state at load time, and
> potentially to tear down state at rmmod time. Add a host template
> ->init_command() and ->exit_command() hook to help with that.
> 
> Signed-off-by: Jens Axboe <axboe@fb.com>

Looks good in general, but please ensure these callsbacks also get invoked
in the !mq case.
