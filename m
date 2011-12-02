From: michaelc@cs.wisc.edu
Subject: qla4xxx fixes
Date: Thu,  1 Dec 2011 21:38:40 -0600
Message-ID: <1322797123-5299-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756475Ab1LBDcF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2011 22:32:05 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pB23W4Qg026927
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2011 22:32:04 -0500
Received: from meanminna.corp.redhat.com (vpn-8-77.rdu.redhat.com [10.11.8.77])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id pB23W3nC008658
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2011 22:32:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches were made against scsi-rc-fixes and fix
regression that were added in 3.2-rc1. If it is possible they
should go into 3.2. If not then they should go into 3.3 and
then sent to 3.2 stable.

