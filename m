From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [RESEND PATCH 0/8] iscsi update
Date: Fri, 13 Jan 2006 18:05:30 -0600
Message-ID: <1137197130.2720.30.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:29876 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1422993AbWANAFh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 19:05:37 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k0E05ZLW021718
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 18:05:36 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a resend of the last iscsi patches I sent yesterday
http://marc.theaimsgroup.com/?l=linux-scsi&m=113712848705512&w=2
but they address Christoph's comments, fix the mutex usage, and some are
rediffed so that they apply cleanly or are dropped becuase of
how we handled Christoph's comments.

This patchset was made against scsi-misc and fixes xfs and jfs support,
xfs or st or sg with 4k stacks, highmem support, reworks the transport
class to allow HW iscsi to hook in and fixes several refcount bugs.

