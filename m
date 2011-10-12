From: Christoph Hellwig <hch@lst.de>
Subject: ib_srpt status
Date: Wed, 12 Oct 2011 11:23:18 +0200
Message-ID: <20111012092318.GA9405@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38719 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab1JLJXT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Oct 2011 05:23:19 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Barn Van Assche <bvanassche@acm.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Roland, hi Nick,

what is the status of queueing up ib_srpt for mainline?  It's a very
clean looking driver that was submitted 8 month ago and after an initial
round of fixes only saw updates for changing core APIs.

Keeping it out of tree for so long is a very discuraging story for
contributors.
