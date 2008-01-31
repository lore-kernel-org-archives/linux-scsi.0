From: michaelc@cs.wisc.edu
Subject: Add target queueing limit helpers to scsi-ml
Date: Thu, 31 Jan 2008 15:36:34 -0600
Message-ID: <1201815396998-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbYAaVgh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 16:36:37 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m0VLabCJ006930
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jan 2008 16:36:37 -0500
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0VLaat5008244
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jan 2008 16:36:36 -0500
Received: from localhost.localdomain (vpn-15-105.rdu.redhat.com [10.11.15.105])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0VLaa5P025875
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jan 2008 16:36:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

These two patches are for RFC, but could go into scsi-misc for
2.6.26 if they are ok off the bat.

They add the ability to limit queueing at the target level.
This will be needed for bnx2i, but also may be useful to
limit transport level commands when using bsg.


