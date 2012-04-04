From: michaelc@cs.wisc.edu
Subject: be2iscsi update v2
Date: Tue,  3 Apr 2012 23:41:35 -0500
Message-ID: <1333514512-21799-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab2DDEln (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Apr 2012 00:41:43 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q344fhF7001356
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 4 Apr 2012 00:41:43 -0400
Received: from meanminna.corp.redhat.com (vpn-10-22.rdu.redhat.com [10.11.10.22])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q344fghm018360
	for <linux-scsi@vger.kernel.org>; Wed, 4 Apr 2012 00:41:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches fix several bugs and add the ability to setup
the cards networking. 

v2:
- Fix bug where phwi_ctrlr is used when not initialized.
- Fix include order.

