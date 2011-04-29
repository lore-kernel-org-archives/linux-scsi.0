From: michaelc@cs.wisc.edu
Subject: iscsi bugfixes
Date: Fri, 29 Apr 2011 14:30:05 -0500
Message-ID: <1304105408-2710-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab1D2TaM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2011 15:30:12 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p3TJUCwh019939
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 29 Apr 2011 15:30:12 -0400
Received: from meanminna.corp.redhat.com (vpn-9-178.rdu.redhat.com [10.11.9.178])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p3TJUBEP025726
	for <linux-scsi@vger.kernel.org>; Fri, 29 Apr 2011 15:30:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches fix a boot/reboot bug with be2iscsi. Without
the patches the driver will hang when the module is loaded.

Patches should be sent to stable if possible.

Patches were made over scsi-misc but also apply to scsi-rc-fixes.

