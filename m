From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 0/9] iscsi update
Date: Wed, 01 Feb 2006 21:06:44 -0600
Message-ID: <1138849604.3456.32.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:27572 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1422885AbWBBDGw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2006 22:06:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

The following patches are built against scsi-misc-2.6 and are not
critical bug fixes so can just go into which every tree you want to put
them in.

The last patch "9/9 iscsi: rm unused sessions list" can be dropped if
you apply Jes Sorensen's SCSI core kmalloc2kzalloc patch before the
iscsi patches. Our last patch and the kmalloc2kzalloc one, patch over
code right next to each other and may not apply cleanly, and since it is
not critical I can resend the last patch some other day when things
settle down.

