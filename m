From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: [ANNOUNCE] iSCSI Initiator Core Stack v1.6.1.23 for 2.6.12-rc1
Date: Mon, 21 Mar 2005 04:01:44 -0800
Message-ID: <1111406504.13496.79.camel@haakon>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from smtp818.mail.sc5.yahoo.com ([66.163.170.4]:44470 "HELO
	smtp818.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261759AbVCUMHU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 07:07:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: iscsi-initiator-core-announce <iscsi-initiator-core-announce@iscsi-initiator-core.org>, iscsi-initiator-core-devel <iscsi-initiator-core-devel@iscsi-initiator-core.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

The following is v1.6.1.23 of the iSCSI Initiator Core Stack for
2.6.12-rc1.  This release adds support for iSCSI Authentication with
v2.2 of iscsi-initiator-core-tools.  This release also fixes issues with
underflow/residual counts that have been reported by various iSCSi
Target vendors.  If any iSCSI target vendors have been waiting for a
release to test with, this is that release.

We are getting very close to a stable 1.6.2.0 release.  I urge everyone
who even has the slightest interest in iSCSI SAN Topography to test this
one out.

http://www.kernel.org/pub/linux/kernel/people/nab/iscsi-initiator-core/iscsi-initiator-core-1.6.1.23-2.6.12-rc1.patch.bz2

A huge thanks go out to following people for contributing to this
release:

Ming Zhang
Eddy Quicksall
David Wysochanski
Mike Christie
AJ Lewis
Bryan Black
Sig Lange

We are always looking for more users and freedback! Everyone is welcome
to join the lists at http://iscsi-initiator-core.org

Thanks!

-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>
Chief Architect, PyX Technologies, Inc
http://iscsi-initiator-core.org

