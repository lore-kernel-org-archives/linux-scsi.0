From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: [ANNOUNCE] iSCSI Initiator Core Stack v1.6.1.20
Date: Wed, 23 Feb 2005 11:45:35 -0800
Message-ID: <1109187935.15154.164.camel@haakon>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from smtp813.mail.sc5.yahoo.com ([66.163.170.83]:8843 "HELO
	smtp813.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261548AbVBWTst (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 14:48:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <mikenc@us.ibm.com>, Andre Hedrick <andre@pyxtechnologies.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

The following is the first public release of the PyX Technologies iSCSI
Initiator Core Stack v1.6.1.20 for Linux 2.6.11-rc4.  This is a full
featured iSCSI Initiator stack that is capable of mulitplexing coast to
coast across multiple independant backbone providers using various
network transports _TODAY_.  This is the first release of the core stack
and assoicated userspace tools, the accompanying authentication daemon
will be released shortly.

There is ongoing work in taking advantage of the very latest 2.6
kernel's SCSI functionality, namely drivers/scsi/scsi_transport_iscsi.c.
The near term work for the iSCSI Initiator Core Stack includes taking
advantage of these new abstractions in scsi_transport_scsi.c in a manner
to reduce code duplication across the iSCSI Initiator Core Stack and
linux-sfnet implementations.  An initial patch to scsi_transport_scsi.c
will be provided in order stay in line with the iSCSI Session/Connection
contexts definied in section 12 of RFC 3720.  Additionally this patch
will add initial support for iSCSI Extentions for RDMA (iSER)
optertional keys in order to help facilitate development of iSCSI with
RDMA Capable Protocols (RCP) in the Linux 2.6 environment.

The patch against 2.6.11-rc4 in diff format can be found at:

http://www.kernel.org/pub/linux/kernel/people/nab/iscsi-initiator-core

The assoicated userspace tools and documentation:

http://www.kernel.org/pub/linux/utils/storage/iscsi

For more information on the Internet Small Computer Systems Interface
(iSCSI) standard, please see:

http://www.ietf.org/rfc/rfc3720.txt

The iSCSI Initiator Core Stack contains, but is not limited to the
following features:

1) Full support for Internet Small Computer Systems Interface (iSCSI)
state machine as defined by RFC 3720.
2) Full support for ErrorRecoveryLevel=0 feature set as defined for RFC
3720.
3) Full support for Multiple Connections per Session that can be brought
up and down on the fly.
4) Full support for DataPDUInOrder=No, DataSequenceInOrder=No,
MaxOutstandingR2T>1.
5) Full support for Sync and Steering using Fixed Interval Markers. (See
RFC 3720 Appendix A)
6) Full support for TCP and SCTP network transports.
7) Robust set of iSCSI Channel management options for iSCSI SAN
Administrators.
8) Tested on UP/SMP 32/64-bit Big/Little Endian architectures.


-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>
Chief Architect, PyX Technologies, Inc.

