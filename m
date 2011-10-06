From: michaelc@cs.wisc.edu
Subject: iscsi changes for scsi-misc
Date: Thu,  6 Oct 2011 03:56:56 -0500
Message-ID: <1317891420-7116-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058Ab1JFIvm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Oct 2011 04:51:42 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p968pg38011323
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 6 Oct 2011 04:51:42 -0400
Received: from meanminna.corp.redhat.com (vpn-8-125.rdu.redhat.com [10.11.8.125])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p968peOm008312
	for <linux-scsi@vger.kernel.org>; Thu, 6 Oct 2011 04:51:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches fix several bugs in the iscsi iface interface
that is being added in scsi-misc-2.6. It also has a patch to use
the IDA code instead of our own loops to find target ids.

Patches were made over scsi-misc.

