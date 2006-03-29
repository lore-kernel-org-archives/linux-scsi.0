From: "Nicholas A. Bellinger" <nab@kernel.org>
Subject: Core-iSCSI v1.6.2.5 & Core-iSCSI-tools v3.3
Date: Wed, 29 Mar 2006 12:41:19 -0800
Message-ID: <1143664879.17194.12.camel@haakon>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp108.sbc.mail.re2.yahoo.com ([68.142.229.97]:6065 "HELO
	smtp108.sbc.mail.re2.yahoo.com") by vger.kernel.org with SMTP
	id S1750947AbWC2Uss (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 15:48:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Core-iSCSI <Core-iSCSI@googlegroups.com>, Open iSCSI <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, iet-dev <iscsitarget-devel@lists.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>

Greetings all,

Core-iSCSI v1.6.2.5 and Core-iSCSI-tools v3.3 are now available from:

http://www.kernel.org/pub/linux/kernel/people/nab/iscsi-initiator-core/core-iscsi-v1.6.2.5.tar.bz2
http://www.kernel.org/pub/linux/utils/storage/iscsi/core-iscsi-tools-v3.3.tar.bz2

The changes a relatively minor relating to a fix for core-iscsi on ARM
(namely the Nokia 770), as well as some fixes related to using the
core-iscsi-tools scripts in a busybox environment.  v3.3 of the tools
should also fix the authentication problem that appeared with v1.6.2.5
of the stack.

On a related note, the wiki on http://www.linux-iscsi.org has been
filling in nicely, and I would like to thank everyone that has
contributed.  linux-iscsi.org will continue to move forward the
evolution of Linux/iSCSI on all platfroms along with the Open/iSCSI and
IET development communities.

Thanks!

-- 
Nicholas A. Bellinger <nab@kernel.org>

