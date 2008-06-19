From: "Karen Xie" <kxie@chelsio.com>
Subject: [PATCH 0/3 2.6.27] cxgb3i: Add iSCSI driver
Date: Wed, 18 Jun 2008 22:10:00 -0700
Message-ID: <8A71B368A89016469F72CD08050AD334D7128B@maui.asicdesigners.com>
References: <8A71B368A89016469F72CD08050AD334D71285@maui.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:19851 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbYFSFn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2008 01:43:58 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, Divy Le Ray <divy@chelsio.com>
Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org, security@kernel.org


Please review the iSCSI drivers for Chelsio CXGB3 (S3XX) devices.  

Here is a brief description of the patch series:
- added iscsi support to cxgb3 driver
- added pdu digest offload and payload direct-placement support to open-iscsi
- the cxgb3i iscsi driver

Thanks.

















