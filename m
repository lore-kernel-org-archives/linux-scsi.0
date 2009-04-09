From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/6] mpt fusion: RESEND: fix for previous patch taskmgmt in progess should be cleared before return
Date: Thu, 9 Apr 2009 16:33:23 +0530
Message-ID: <20090409110315.GA5255@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:58657 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbZDILWb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2009 07:22:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Resending patch set considering comments for my previous patch set.
These patches are created on top of MPT fusion previous patch applied on
date 26/02/2009 with subject line: "mpt fusion: config, Taskmgmt cmd,
Internal cmd, Ioctl cmd changes"

Some patches are splited into two diffrent patches only for readability
purpose for reviewer.

Consider below patches as one logical patch. There is no harm to send
those patches as single patch, but to give more readability I have choosen
to split.
PATCH 2 and PATCH 3.
PATCH 4 and PATCH 5.

PATCH 3 and PATCH 5 include only those function which are not part of MPT
fusion.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
