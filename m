From: "Karen Xie" <kxie@chelsio.com>
Subject: RE: [PATCH 1/2 2.6.29] cxgb3 - manage private iSCSI IP address
Date: Mon, 8 Dec 2008 13:11:20 -0800
Message-ID: <8A71B368A89016469F72CD08050AD33403F15217@maui.asicdesigners.com>
References: <200812082030.mB8KU37N029242@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:17855 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbYLHVLS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Dec 2008 16:11:18 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

Sorry, forgot to add my signed off line, it should be:

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: Karen Xie <kxie@chelsio.com>


-----Original Message-----
From: Karen Xie [mailto:kxie@chelsio.com] 
Sent: Monday, December 08, 2008 12:30 PM
To: open-iscsi@googlegroups.com; linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu; James.Bottomley@HansenPartnership.com; Karen
Xie
Subject: [PATCH 1/2 2.6.29] cxgb3 - manage private iSCSI IP address

[PATCH 1/2 2.6.29] cxgb3 - manage private iSCSI IP address

From: Karen Xie <kxie@chelsio.com>

The accelerated iSCSI traffic could use a private IP address unknown to
the OS:
- Create a per port sysfs entry to pass an IP address to the NIC driver,
and a
  control call for the iSCSI driver to grab it.
- The IP address is required in both drivers to manage ARP requests and
  connection set up.
- Reply to ARP requests dedicated to the private IP address.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

