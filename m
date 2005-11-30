From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 0/8] iscsi update
Date: Tue, 29 Nov 2005 23:12:33 -0600
Message-ID: <1133327553.28356.36.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46010 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751008AbVK3FMk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 00:12:40 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id jAU5CcoG009266
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:12:39 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I get to be the patch monkey again so here is a iscsi update. The
following patches except 01 and 04 are bug fixes. Patch 01 and 04 begin
to add support for other interconnects like rdma. We are not sending
support for rdma at this time. Those two patches should be netlink and
sysfs values that are some what interesting for the code we have in
mainline. If someone has a problem with those patches the patchset can
live without them though (it will apply at a offset but be ok).

We know we are late for 2.6.15 and that those two patches do not qualify
for rc bugfixes so we understand if this gets queued to 2.6.16-rc1.
Patches were made against scsi-misc but apply to scsi-rc-fixes.

