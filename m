From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 0/9] iscsi updates
Date: Mon, 12 Sep 2005 21:01:23 -0500
Message-ID: <1126576883.29245.20.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:16825 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932303AbVIMCB1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 22:01:27 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8D21Qfe010012
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2005 21:01:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

It looks like I won the contest to be the patch monkey, so I get the
chore to send some iscsi updates for the open-iscsi group. The following
patchset is made against scsi-misc. It is just bug fixes and some
cleanups.

