From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/8] mpt fusion: config, Taskmgmt cmd, Internal cmd, Ioctl cmd changes
Date: Thu, 26 Feb 2009 12:28:27 +0530
Message-ID: <20090226065820.GA26209@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:47898 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZBZHUc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Feb 2009 02:20:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Sathya.Prakash@lsi.com, eric.moore@lsi.com

These patches are created on top of MPT fusion previous patch applied on
date 21/01/2009 with subject line: "Fixing 1078 data corruption issue for
36FGB memory region resubmitted"

Some patches are splited into two diffrent patches only for readability
purpose for reviewer.

Consider below patches as one logical patch. There is no harm to send
those patches as single patch, but to give more readability I have choosen
to split.
PATCH 2 and PATCH 3.
PATCH 5 and PATCH 6.

PATCH 3 and PATCH 6 include only those function which are not part of MPT
fusion.

