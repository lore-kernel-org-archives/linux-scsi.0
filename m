From: "Michael Chan" <mchan@broadcom.com>
Subject: [PATCH 0/5] cnic: Bug fixes.
Date: Fri, 14 Aug 2009 18:49:42 -0700
Message-ID: <1250300987-18407-1-git-send-email-mchan@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3644 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337AbZHOBnA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Aug 2009 21:43:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: davem@davemloft.net, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu
Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org


This patchset fixes a panic on ia64 and some locking issues.
Please review.  Thanks.

