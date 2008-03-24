From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/5] sweep up functions to build sense data
Date: Tue, 25 Mar 2008 01:54:50 +0900
Message-ID: <1206377695-26084-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:57085 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183AbYCXQ52 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Mar 2008 12:57:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, James.Bottomley@HansenPartnership.com, dougg@torque.net, jeff@garzik.org, ed.lin@promise.com, Geert.Uytterhoeven@sonycom.com

We have several similar functions to build sense data. This patchset
just adds a simple helper function to do the same job and sweeps them
up.


