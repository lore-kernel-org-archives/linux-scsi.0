From: michaelc@cs.wisc.edu
Subject: [RFC 0/4]: offlined device changes
Date: Thu, 19 Apr 2012 20:08:52 -0500
Message-ID: <1334884136-3689-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab2DTBI6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Apr 2012 21:08:58 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q3K18v3b025100
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 19 Apr 2012 21:08:57 -0400
Received: from meanminna.corp.redhat.com (vpn-9-38.rdu.redhat.com [10.11.9.38])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q3K18uoc029763
	for <linux-scsi@vger.kernel.org>; Thu, 19 Apr 2012 21:08:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches were made over scsi-misc.

The first 3 patches add a new state, SDEV_TRANSPORT_OFFLINE, which
can be used by transport classes to offline devices. This replaces
the behavior where they set some value in their check ready functions
then set the devices to running to fail IO.

The last patch has scsi-ml send a KOBJ_CHANGE event when transitioning
from SDEV_TRANSPORT_OFFLINE or SDEV_OFFLINE to SDEV_RUNNING.


