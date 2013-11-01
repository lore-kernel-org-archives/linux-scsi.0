From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] hpsa: return 0 from driver probe function on success, not 1
Date: Fri, 01 Nov 2013 11:02:20 -0500
Message-ID: <20131101155851.17783.73732.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:31192 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab3KAQCY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2013 12:02:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, scott.teel@hp.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com

Just resending the patch with a better change log message (as requested
by Andrew Morton) and cc'ing stable@vger.kernel.org, (as I originally
had intended.)

---

Stephen M. Cameron (1):
      hpsa: return 0 from driver probe function on success, not 1


 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
-- steve
