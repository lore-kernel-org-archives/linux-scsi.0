From: michaelc@cs.wisc.edu
Subject: Add fc host dev loss sysfs file
Date: Wed, 15 Sep 2010 16:52:27 -0500
Message-ID: <1284587552-7617-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab0IOVqy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 17:46:54 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8FLkr99015935
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 15 Sep 2010 17:46:54 -0400
Received: from meanminna.corp.redhat.com (vpn-11-40.rdu.redhat.com [10.11.11.40])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o8FLkqNS005720
	for <linux-scsi@vger.kernel.org>; Wed, 15 Sep 2010 17:46:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

These patches add a FC host dev loss sysfs file that stores
the default dev loss tmo value and updates the existing
rport's dev loss setting.

The patchset was made over scsi-misc.

[PATCH 1/5] fnic: prep for fc host dev loss tmo support
[PATCH 2/5] ibmvfc: prep for fc host dev loss tmo support
[PATCH 3/5] qla2xxx: prep for fc host dev loss tmo support
[PATCH 4/5] lpfc: prep for fc host dev loss tmo support
[PATCH 5/5] fc class: add fc host dev loss sysfs file
