From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bug 80711] SG_FLAG_LUN_INHIBIT is no longer implemented and
 there's not way to prevent the kernel from using the 2nd cdb byte for the
 LUN
Date: Tue, 22 Jul 2014 09:13:27 -0700
Message-ID: <20140722161327.GA21650@infradead.org>
References: <bug-80711-11613@https.bugzilla.kernel.org/>
 <bug-80711-11613-K93vbWd0lq@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42059 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaGVQN1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jul 2014 12:13:27 -0400
Content-Disposition: inline
In-Reply-To: <bug-80711-11613-K93vbWd0lq@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

This is going in the wrong direction.  If your device doesn't like
the LUN field in the CDB it misreports the standard compliance level.

We'll need to fix that root cause, probably by a black list entry
instead of hacking around it in userspace.

