From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH for-2.6.39] [SCSI] scsi_dh_emc: fix panic when handling
 multiple path failures
Date: Mon, 21 Mar 2011 15:44:09 -0500
Message-ID: <1300740249.10634.43.camel@mulgrave.site>
References: <1300737433-11994-1-git-send-email-snitzer@redhat.com>
	 <1300737774.10634.37.camel@mulgrave.site>
	 <20110321203829.GB12157@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441Ab1CUUoO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 16:44:14 -0400
In-Reply-To: <20110321203829.GB12157@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Eddie Williams <eddie.williams@steeleye.com>

On Mon, 2011-03-21 at 16:38 -0400, Mike Snitzer wrote:
> Anyway, it's now on my plate to sort out.  No idea if I'll do so by the
> close of the merge window.  But maybe a real fix to this can go in after
> the window closes?

It's a bug fix: of course it can.

James


