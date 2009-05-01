From: "Michael Chan" <mchan@broadcom.com>
Subject: [PATCH 0/4] Add bnx2 iscsi support.
Date: Fri, 1 May 2009 13:00:35 -0700
Message-ID: <1241208039-6813-1-git-send-email-mchan@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1970 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762491AbZEAUwQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 May 2009 16:52:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: davem@davemloft.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com
Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com


Adding linux-scsi and James to CC, please review.  David
has ACK'ed the networking portion.  We have also fixed up
some sparse warnings.  The iscsi patches require these 2
patches from the iscsi tree:

    libiscsi: export iscsi_itt_to_task for bnx2i
    iscsi: pass ep connect shost


