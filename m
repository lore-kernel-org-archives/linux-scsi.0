From: michaelc@cs.wisc.edu
Subject: iscsi bugfixes
Date: Mon, 16 Oct 2006 18:09:37 -0400
Message-ID: <11610365823995-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52673 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1422859AbWJPXJb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 19:09:31 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k9GN9UZM022764
	for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2006 19:09:30 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id k9GN9UrQ008038
	for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2006 19:09:30 -0400
Received: from localhost.localdomain (vpn-14-30.rdu.redhat.com [10.11.14.30])
	by pobox.corp.redhat.com (8.13.1/8.12.8) with ESMTP id k9GN9Tff020538
	for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2006 19:09:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

These next patches fix iscsi interop bugs and oopses. The patches
were made against scsi-misc but apply to scsi-rc-fixes cleanly.


