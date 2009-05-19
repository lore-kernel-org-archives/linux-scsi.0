From: michaelc@cs.wisc.edu
Subject: RFC: handle queue_depth adjustments because of QUEUE_FULLs in scsi_error.c
Date: Tue, 19 May 2009 00:52:43 -0500
Message-ID: <12427123683166-git-send-email-michaelc@cs.wisc.edu>
References: <12427123671020-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57026 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbZESFws (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2009 01:52:48 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n4J5qo2Y002725
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2009 01:52:50 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4J5qncj005789
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2009 01:52:49 -0400
Received: from localhost.localdomain (vpn-12-139.rdu.redhat.com [10.11.12.139])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n4J5qmZC008403
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2009 01:52:49 -0400
In-Reply-To: <12427123671020-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

