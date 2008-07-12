From: michaelc@cs.wisc.edu
Subject: scsi tcq fixes for 2.6.27 take 2
Date: Fri, 11 Jul 2008 19:50:31 -0500
Message-ID: <1215823835-4865-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112AbYGLAvJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2008 20:51:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, promise_linux@promise.com, david.somayajulu@qlogic.com

The following patches fix a couple bugs in the shared tag map code.
The patches were made over scsi-misc. I tested with qla4xxx, but do not
have hardware for stex, but the only patch to stex is to set a
safe queue_depth which was already defined.


