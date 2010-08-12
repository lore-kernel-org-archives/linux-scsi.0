From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2] SCSI: fix bio.bi_rw handling
Date: Thu, 12 Aug 2010 09:30:04 -0400
Message-ID: <x49iq3g3qn7.fsf@segfault.boston.devel.redhat.com>
References: <1281616266-4709-1-git-send-email-jslaby@suse.cz>
	<1281616266-4709-2-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab0HLNa4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2010 09:30:56 -0400
In-Reply-To: <1281616266-4709-2-git-send-email-jslaby@suse.cz> (Jiri Slaby's
	message of "Thu, 12 Aug 2010 14:31:05 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, jirislaby@gmail.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>

Jiri Slaby <jslaby@suse.cz> writes:

> Return of the bi_rw tests is no longer bool after commit 74450be1. So
> testing against constants doesn't make sense anymore. Fix this bug in
> osd_req_read by removing "== 1" in test.
>
> This is not a problem now, where REQ_WRITE is 1, but this can change
> in the future and we don't want to rely on that.
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
> Cc: Christoph Hellwig <hch@lst.de>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
