From: michaelc@cs.wisc.edu
Subject: be2iscsi bugfixes
Date: Fri,  7 Oct 2011 19:31:07 -0500
Message-ID: <1318033872-5900-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab1JHAZw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Oct 2011 20:25:52 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p980Ppr7025894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 7 Oct 2011 20:25:52 -0400
Received: from meanminna.corp.redhat.com (vpn-11-1.rdu.redhat.com [10.11.11.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p980PpZP008299
	for <linux-scsi@vger.kernel.org>; Fri, 7 Oct 2011 20:25:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches were made over scsi-misc. They fix several bugs
including a oops in the IO path and a boot/loading failure.

This might be a duplicate for some people. Jay had tried to send
to the list but it does not look like it is showing up. Some
people on his cc list when he sent before may have got the mails
(some did not).



