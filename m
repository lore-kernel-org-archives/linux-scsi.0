From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] sg_cmd_done - another oops
Date: Sun, 6 Jun 2004 16:32:22 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0406061631290.2029-100000@poirot.grange>
References: <20040606084925.GA2733@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60385 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263714AbUFFPHk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2004 11:07:40 -0400
In-Reply-To: <20040606084925.GA2733@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Brian King <brking@us.ibm.com>, dougg@torque.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Sun, 6 Jun 2004, Jens Axboe wrote:

> interrupt -> sg_cmd_done -> sg_finish_rem_req -> write_lock on
> rq_list_lock.

I see, thanks!

Guennadi
---
Guennadi Liakhovetski


