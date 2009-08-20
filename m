From: michaelc@cs.wisc.edu
Subject: iscsi update for 2.6.32
Date: Thu, 20 Aug 2009 15:10:56 -0500
Message-ID: <1250799063-1843-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbZHTULE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 16:11:04 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7KKB4Yi016386
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2009 16:11:05 -0400
Received: from localhost.localdomain (vpn-13-78.rdu.redhat.com [10.11.13.78])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n7KKB3m1009110
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2009 16:11:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches are for 2.6.32. They were made againsts
scsi-misc. There is not really anything interesting. The only
new feature is Erez's logging changes, that allow you do
turn logging on at run time.

There are some bug fixes which improve detection of when the
target closes the connection on us, and a fix for the cmdsn
management when using bnx2i.


