From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/10] [FCoE] This patch set removes the ASSERT code in
	Open-FCoE.
Date: Tue, 22 Jan 2008 16:35:23 -0800
Message-ID: <20080123003523.8469.62236.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:7302 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756493AbYAWAtQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 19:49:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following series removes the sa_assert.[ch] files. It also converts
all calls to ASSERT* to either WARN_ON or ERROR_ON calls. This is part of 
the effort to remove libsa.

--
Signature
