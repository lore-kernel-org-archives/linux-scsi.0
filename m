From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: [ANNOUNCE] iSCSI Initiator Core Tools v2.2
Date: Mon, 21 Mar 2005 04:01:49 -0800
Message-ID: <1111406509.13496.80.camel@haakon>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from smtp806.mail.sc5.yahoo.com ([66.163.168.185]:16222 "HELO
	smtp806.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261760AbVCUMHc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 07:07:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: iscsi-initiator-core-announce <iscsi-initiator-core-announce@iscsi-initiator-core.org>, iscsi-initiator-core-devel <iscsi-initiator-core-devel@iscsi-initiator-core.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

The following is v2.2 of the iscsi-initiator-core-tools.  This release
contains support for iSCSI Authentication by way of initiator-authd.
This release also adds support for generating unique iSCSI Initiator
Node Names and using the same /etc/initiatorname.iscsi format as
linux-sfnet in order to ease transition between existing iSCSI SAN
topography and iscsi-initiator-core.org.

Please upgrade your existing iscsi-initiator-core installations to this
release.

http://www.kernel.org/pub/linux/utils/storage/iscsi/iscsi-initiator-core-tools-2.2.tar.bz2

A huge thanks go out to the following people for contributing to this
release:

Ming Zhang
Eddy Quicksall
David Wysochanski
Mike Christie
AJ Lewis
Bryan Black
Sig Lange

We are always looking for more users and feedback! Everyone is welcome
to join the lists at http://iscsi-initiator-core.org

Thanks!

-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>
Chief Architect, PyX Technologies, Inc
http://iscsi-initiator-core.org

