From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: [ANNOUNCE] iscsi-initiator-core 1.6.2.0-rc1 for 2.6.12-rc1
Date: Fri, 01 Apr 2005 12:01:41 -0800
Message-ID: <1112385701.3008.18.camel@haakon>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp811.mail.sc5.yahoo.com ([66.163.170.81]:52843 "HELO
	smtp811.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S262871AbVDAUI7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2005 15:08:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: iscsi-initiator-core-announce@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Cc: iscsi-initiator-core-devel <iscsi-initiator-core-devel@iscsi-initiator-core.org>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <mikenc@us.ibm.com>

Greetings all,

http://www.kernel.org/pub/linux/kernel/people/nab/iscsi-initiator-core/iscsi-initiator-core-1.6.2.0-rc1-2.6.12-rc1.patch.bz2

A few minor fixes in this release, with the main feature addition being
support for persistent connection/session parameters as defined within 
/etc/sysconfig/initiator.  For example, it is now possible to define
specific connection/session parameters and have those values remain
throughout connection/session failures.  Also, the first run of tests
with dm-multipath have been compelted successful.  I am working on a
section within the documentation to describe how these two pieces work
together within linux 2.6.

Also an important milestone has been reached with v1.0 of the
iscsi-initiator-core.org howto located at:

http://iscsi-initiator-core.org/mediawiki/index.php/Howto

This is a work in progress as data is imported from the ASCII version
from iscsi-initiator-core-tools v2.3.

This release is now considered stable and no new features will be added
until 1.6.2.0-final is released.

Thanks!

-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>
Chief Architect, PyX Technologies, Inc.
http://www.iscsi-initiator-core.org

