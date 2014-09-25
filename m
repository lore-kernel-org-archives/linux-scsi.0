From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 20/35] qla2xxx: Unload of qla2xxx driver crashes the
	machine.
Date: Thu, 25 Sep 2014 10:37:27 +0200
Message-ID: <20140925083727.GA9227@lst.de>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com> <1411542518-2477-21-git-send-email-saurav.kashyap@qlogic.com> <20140924094125.46eac20f@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55949 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbaIYIha (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 04:37:30 -0400
Content-Disposition: inline
In-Reply-To: <20140924094125.46eac20f@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>, jbottomley@parallels.com, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Wed, Sep 24, 2014 at 09:41:25AM -0400, Joe Lawrence wrote:
> Hi Saurav,
> 
> Will these changes conflict with those submitted in August [1] to
> Christoph's drivers-for-3.18 branch?

It does cause conflicts when applying the patch at least.  Chad, can you
please resend the series against the drivers-for-3.18 branch of
git://git.infradead.org/users/hch/scsi-queue.git ?  Please do so today
so that we don't miss the merge window.

