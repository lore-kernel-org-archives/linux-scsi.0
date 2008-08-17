From: michaelc@cs.wisc.edu
Subject: allow scsi-ml to manage target queueing limits (v3)
Date: Sun, 17 Aug 2008 15:24:37 -0500
Message-ID: <1219004683-6468-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47566 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbYHQUYu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Aug 2008 16:24:50 -0400
Received: from localhost (c-75-73-66-60.hsd1.mn.comcast.net [75.73.66.60])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id m7HKOnvA020340
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 17 Aug 2008 15:24:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

These next patches, made over scsi-misc, allow classes or drivers
to allow scsi-ml to control target/session/rport level queueing
limitations. This comes in handy for transitioning those structs states,
or if the hardware has a queueing limit at that level.

The only difference between v2 and v3 is that for the first patch,
0001-scsi-Add-helper-code-so-transport-classes-driver-ca.patch,
I rediffed it for scsi-misc which had some conflicting changes with
the old patch. And I readded patches for the fc and software iscsi drivers.



