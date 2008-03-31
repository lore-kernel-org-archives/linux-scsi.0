From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/5] bsg lifetime management fix and some improvements
Date: Mon, 31 Mar 2008 10:03:37 +0900
Message-ID: <1206925422-4722-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:58053 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567AbYCaBFK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 21:05:10 -0400
In-Reply-To: 20080331092020R.fujita.tomonori@lab.ntt.co.jp
References: 20080331092020R.fujita.tomonori@lab.ntt.co.jp
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, pw@osc.edu, tomof@acm.org, James.Bottomley@HansenPartnership.com, Jens.Axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp

This patchset includes a patch to fix lifetime management problems
that Pete reported:

http://marc.info/?l=linux-scsi&m=120508166505141&w=2
http://marc.info/?l=linux-scsi&m=120508177905365&w=2
http://marc.info/?l=linux-scsi&m=120508178005376&w=2

The rest for improvement.

The first patch (and the second patch possibly) can go via scsi-fixes
and the rest should go via scsi-misc. We are already in rc7 and there
are not many bsg users yet so I guess that it's also ok to push all
the patches to via scsi-misc (I'll send the first one to stable later
on in this case).



