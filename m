From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3] scsi_lib: rate-limit the error message from failing
 commands
Date: Thu, 30 Aug 2012 16:25:00 -0700
Message-ID: <503FF64C.6040409@kernel.dk>
References: <20120830210607.28119.96438.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:37326 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab2H3XZQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Aug 2012 19:25:16 -0400
In-Reply-To: <20120830210607.28119.96438.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yi Zou <yi.zou@intel.com>
Cc: James.Bottomley@HansenPartnership.com, "www.Open-FCoE.org" <devel@open-fcoe.org>, Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org

On 2012-08-30 14:06, Yi Zou wrote:
> [
> Jens/James,
> 
> This is a rather old rate limt patch but never gets picked up in upstream, so I
> am resending it here as v3, with some minor changes so it is directly applicable
> to the current linux-2.6.git tree. I don't have that many LUNs that the original
> issue was reported but the patch was already reviewed and acked in the past,
> I did retest w/ stress I/O on 4 LUNs I have right now.
> 
> Original thread can be found at:
> http://comments.gmane.org/gmane.linux.scsi/73497
> http://www.open-fcoe.org/patchwork/patch/2436/
> 
> Can you please pull this patch in? it's been hanging there for a long time.
> Original patch description is below.

I've pulled in the block bit.

-- 
Jens Axboe

