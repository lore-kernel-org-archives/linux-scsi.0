From: michaelc@cs.wisc.edu
Subject: iscsi changes for scsi-misc
Date: Fri,  9 Apr 2010 22:07:35 -0500
Message-ID: <1270868859-5147-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab0DJDHm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 23:07:42 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o3A37fvJ002041
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 9 Apr 2010 23:07:41 -0400
Received: from localhost.localdomain (vpn-11-118.rdu.redhat.com [10.11.11.118])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o3A37eIf029619
	for <linux-scsi@vger.kernel.org>; Fri, 9 Apr 2010 23:07:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here are some cleanups and a small fix. Nothing in here is critical so
they can go into scsi-misc.

The patchset was made over scsi-misc and this patch which
is not yet merged:
http://marc.info/?l=linux-scsi&m=127006425722598&w=2
(this patch is a bug fix that should go into scsi-rc-fixes if possible).


