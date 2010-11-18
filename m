From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5] dm mpath: avoid call to blk_abort_queue
	by default
Date: Thu, 18 Nov 2010 20:18:41 +0000
Message-ID: <20101118201841.GE30435@agk-dp.fab.redhat.com>
References: <1290107959-17167-1-git-send-email-snitzer@redhat.com> <1290110853-17541-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702Ab0KRUTD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 15:19:03 -0500
Content-Disposition: inline
In-Reply-To: <1290110853-17541-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Mike Christie <michaelc@cs.wisc.edu>, Mike Anderson <andmike@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

On Thu, Nov 18, 2010 at 03:07:33PM -0500, Mike Snitzer wrote:
> It is expected that this race will be fixed in the near-term so it makes
> little since to remove all associated code.  Providing control over the
> call to blk_abort_queue() facilitates continued testing and future
> flexibility to opt-in to lower latency path deactivation.  Opting to
> enable this feature will emit a warning for the time being.
 
Ah, but then the *feature* keyword - which is only going to be needed
temporarily until it's fixed - becomes a permanent part of the interface...

If it's broken, let's just disable it (#define-style) until it gets fixed.
(And only if it doesn't get fixed in a reasonable amount of time, remove the
code.)

Alasdair

