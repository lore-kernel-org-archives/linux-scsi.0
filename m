From: vikas.chaudhary@qlogic.com
Subject: [RFC PATCH 0/3] qla4xxx: support session management using iscsiadm
Date: Fri,  6 May 2011 05:29:50 -0700
Message-ID: <1304684993-1715-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36724 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751780Ab1EFMgC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2011 08:36:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

These are RFC patches to support qla4xxx session management from userspace
using iscsiadm.

Kernel patches:

Lalit Chandivade (3):
	scsi_transport_iscsi: Add flag CAP_LOGIN_OFFLOAD
	qla4xxx: support session management using iscsiadm.
	qla4xxx: Remove reduandant code after open-iscsi integration.

iscsiadm patche:

Manish Rangankar (1):
	iscsi tools: manage qla4xxx iscsi sessions with iscsiadm

Thanks,
Vikas.
