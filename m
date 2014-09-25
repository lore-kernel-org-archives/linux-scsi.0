From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 20/35] qla2xxx: Unload of qla2xxx driver crashes the
	machine.
Date: Thu, 25 Sep 2014 11:03:34 +0200
Message-ID: <20140925090333.GA9777@lst.de>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com> <1411542518-2477-21-git-send-email-saurav.kashyap@qlogic.com> <20140924094125.46eac20f@jlaw-desktop.mno.stratus.com> <20140925083727.GA9227@lst.de> <F5D084D6342F9B479C34599BB0A03E4D012855F54E@AVMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56035 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbaIYJDh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:03:37 -0400
Content-Disposition: inline
In-Reply-To: <F5D084D6342F9B479C34599BB0A03E4D012855F54E@AVMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Sep 25, 2014 at 08:57:18AM +0000, Saurav Kashyap wrote:
> Hi Christoph,
> I will rebase and send an updated patch set soon.

Thanks.  Did you verify the target side series sits nicely on top of this
one as well?  I'd like to slurp in the qla2xxx patches as well if Nick
is fine with them, although I'd prefer to leave the target core changes
for his target tree.  As far as I can tell there is no hard dependency
of the qla2xxx changes on those two, right?  Next time it might be good
idea to send them as two separate series.
