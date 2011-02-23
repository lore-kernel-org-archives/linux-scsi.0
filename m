From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: [LSF/SCSI ATTEND] Continuation of discussions to represent CNA and
 its attributes in Linux system.
Date: Wed, 23 Feb 2011 14:24:46 -0800
Message-ID: <C98AC92E.11C49%giridhar.malavali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:53912 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab1BWWYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2011 17:24:50 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "lsf-pc@lists.linuxfoundation.org" <lsf-pc@lists.linuxfoundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>

At present there is no clear way of representing the CNA and its
attributes in Linux system.
The initial proposal with patch was submitted to address this. Here is the
pointer for the submission.
 http://marc.info/?l=linux-scsi&m=124026598328893&w=2

This triggered a series of discussions for representing FC as a bus in
sysfs which could represent both FC and FCoE.
During last summit, the topic was discussed further but the challenge to
represent non-scsi end points because of converged
technology could not be addressed completely. With no better
representation the current proposal was agreed and patches
were submitted for better solution.

http://marc.info/?t=127369568900001&r=1&w=2
http://open-fcoe.org/rwlove/fc_sysfs.jpg

I would like to attend to discuss more in the following areas.

1) Generalized implementation of new FC sysfs and FCoE to address both
offloaded and non-offloaded adapters.
 The current submission address the new FC sysfs and FCoE changes w.r.t
non-offloaded adapters perspective.
This needs to be generalized to address both offloaded and non-offloaded
adapters. I would like to discuss more for a generic approach here.

2) Represent the non-scsi end points and common attributes across both FC
and ethernet in sysfs layout.

Giridhar Malavalli


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

