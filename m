From: michaelc@cs.wisc.edu
Subject: RFC: add bsg lib and convert fc and iscsi class
Date: Sat, 10 Apr 2010 05:17:37 -0500
Message-ID: <1270894661-28402-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab0DJKyP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Apr 2010 06:54:15 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o3AAsFg6030224
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2010 06:54:15 -0400
Received: from localhost.localdomain (vpn-9-246.rdu.redhat.com [10.11.9.246])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o3AAHfwq030375
	for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2010 06:17:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

There was not much difference between the fc class and
iscsi class bsg code, so this patchset moves the fc
class code to a scsi lib. The patches were made
over scsi-misc. This is only a RFC. The patchset is only
compile tested. I wanted to make sure it was ok with
the FC people, before I convert all the drivers which
requires a lot of work compared to just converting
the classes.


