From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 5268] New: aic79xx scsi driver causing system
 to hang
Date: Fri, 16 Sep 2005 12:03:13 -0700
Message-ID: <20050916120313.7f8969ba.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:20175 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1161270AbVIPTDr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 15:03:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>


This one's a bit strange.

It's a post-2.6.12 regression.

Begin forwarded message:

Date: Fri, 16 Sep 2005 08:14:12 -0700
From: bugme-daemon@kernel-bugs.osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 5268] New: aic79xx scsi driver causing system to hang


 http://bugzilla.kernel.org/show_bug.cgi?id=5268

            Summary: aic79xx scsi driver causing system to hang
     Kernel Version: 2.6.13.x
             Status: NEW
           Severity: high
              Owner: andmike@us.ibm.com
          Submitter: freelsjd@ornl.gov


 Most recent kernel where this bug did not occur: 2.6.12.6
