From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: SCSI git trees
Date: Wed, 29 Jul 2009 17:07:36 +0000
Message-ID: <1248887256.3900.78.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47303 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754726AbZG2RHj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 13:07:39 -0400
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id A4A358EE0F6
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2009 10:07:39 -0700 (PDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
	by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XAlD-GS6KjDw for <linux-scsi@vger.kernel.org>;
	Wed, 29 Jul 2009 10:07:39 -0700 (PDT)
Received: from [192.168.10.224] (newmulgrave.ext.hansenpartnership.com [192.168.10.224])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 363808EE00E
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2009 10:07:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

It seems I got unsubscribed from linux-scsi last week while I was on
holiday and I've likely missed a slew of patches, it seems like an
appropriate time to remind everyone how the SCSI trees work.

---

There are two git based scsi trees:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git

called the scsi-misc tree for patches being collected for the next merge
window.  And

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

called scsi-fixes for bug fixes collected for current linux head.

Both trees are kept rebasable (no merge points) with all patches head at
the tree head (so you can use gitweb to see what's in them easily). Each
of the trees sends email to the author and all of the signoff chains
when a patch is added, so if you sent a patch in and haven't received an
email (and don't see it in either of the trees) I don't have it.

All trees feed into linux-next and all patches in scsi-misc/scsi-fixes
will be tested in linux-next for a few days before being passed on to
Linus (so no more patches get added at that point).

James

