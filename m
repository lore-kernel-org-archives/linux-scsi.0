From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: [ANNOUNCE] iSCSI Initiator Core Stack v1.6.1.21 for 2.6.11
Date: Fri, 04 Mar 2005 17:42:22 -0800
Message-ID: <1109986942.1786.48.camel@haakon>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from smtp807.mail.sc5.yahoo.com ([66.163.168.186]:13484 "HELO
	smtp807.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S263333AbVCEBqz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Mar 2005 20:46:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <mikenc@us.ibm.com>, Andre Hedrick <andre@pyxtechnologies.com>
Cc: linux-iscsi <linux-scsi@vger.kernel.org>

The following is v1.6.1.21 of the iSCSI Initiator Core Stack for 2.6.11.
This release includes the conversion of existing readonly proc entries
to sysfs, as well as exporting out all iSCSI Channel, Session and
Connection releated attributes.  The procfs entries remain in this
release, and will be removed in the next release once the userspace
tools can be converted to use sysfs.  Also in the release are changes
related to Jeff Garzik's review (Thanks again Jeff!!).

The patch will be appearing shortly at:

http://www.kernel.org/pub/linux/kernel/people/nab/iscsi-initiator-core/

The same userspace tools (2.0) can be located at:

http://www.kernel.org/pub/linux/utils/storage/iscsi/

This release was diffed, built and packaged using itself over an iSCSI
SAN and all future release will continue to follow this procedure.  One
final note before we go into the fun stuff, the mailinglist and website
will be setup by Monday and will be announced with the release of the
next version of the userspace tools. I encourage everyone who is
interested to join the mailing list, now on with the show. :-)

To give the reader an idea of what the /sys/class/iscsi_initiator_core
hierarchy looks like with two (2) iSCSI Channels (Initiator -> Target)
defined with two (2) iSCSI connections per iSCSI Session to each of
those iSCSI Target Nodes.  I am open to discussion on how these entires
should look.  Please give me your comments!

.
|-- channel_10
|   |-- channel_id
|   |-- iscsi
|   |-- scsi
|   `-- sess_8
|       |-- conn_0
|       |   |-- cid
|       |   |-- conn_ops
|       |   |   |-- DataDigest
|       |   |   |-- HeaderDigest
|       |   |   |-- IFMarkInt
|       |   |   |-- IFMarker
|       |   |   |-- MaxRecvDataSegmentLength
|       |   |   |-- OFMarkInt
|       |   |   `-- OFMarker
|       |   |-- expstatsn
|       |   |-- ipv4_address
|       |   |-- network_transport
|       |   `-- port
|       |-- conn_1
|       |   |-- cid
|       |   |-- conn_ops
|       |   |   |-- DataDigest
|       |   |   |-- HeaderDigest
|       |   |   |-- IFMarkInt
|       |   |   |-- IFMarker
|       |   |   |-- MaxRecvDataSegmentLength
|       |   |   |-- OFMarkInt
|       |   |   `-- OFMarker
|       |   |-- expstatsn
|       |   |-- ipv4_address
|       |   |-- network_transport
|       |   `-- port
|       |-- isid
|       |-- sess_ops
|       |   |-- FirstBurstLength
|       |   |-- ImmediateData
|       |   |-- InitialR2T
|       |   |-- InitiatorAlias
|       |   |-- InitiatorName
|       |   |-- MaxBurstLength
|       |   |-- SessionType
|       |   |-- TargetAlias
|       |   `-- TargetName
|       |-- sid
|       `-- tsih
|-- channel_12
|   |-- channel_id
|   |-- iscsi
|   |-- scsi
|   `-- sess_2
|       |-- conn_0
|       |   |-- cid
|       |   |-- conn_ops
|       |   |   |-- DataDigest
|       |   |   |-- HeaderDigest
|       |   |   |-- IFMarkInt
|       |   |   |-- IFMarker
|       |   |   |-- MaxRecvDataSegmentLength
|       |   |   |-- OFMarkInt
|       |   |   `-- OFMarker
|       |   |-- expstatsn
|       |   |-- ipv4_address
|       |   |-- network_transport
|       |   `-- port
|       |-- conn_1
|       |   |-- cid
|       |   |-- conn_ops
|       |   |   |-- DataDigest
|       |   |   |-- HeaderDigest
|       |   |   |-- IFMarkInt
|       |   |   |-- IFMarker
|       |   |   |-- MaxRecvDataSegmentLength
|       |   |   |-- OFMarkInt
|       |   |   `-- OFMarker
|       |   |-- expstatsn
|       |   |-- ipv4_address
|       |   |-- network_transport
|       |   `-- port
|       |-- isid
|       |-- sess_ops
|       |   |-- FirstBurstLength
|       |   |-- ImmediateData
|       |   |-- InitialR2T
|       |   |-- InitiatorAlias
|       |   |-- InitiatorName
|       |   |-- MaxBurstLength
|       |   |-- SessionType
|       |   |-- TargetAlias
|       |   `-- TargetName
|       |-- sid
|       `-- tsih
|-- initiator_nodename
`-- version_info

The channel_#/[iscsi,scsi]_info will remain for the time being to
support the current userspace scripts used to channel management and
persisant mapping of iSCSI Logical Units.  I am open to discussion on
how these entires should look.  Please give me your comments!

Thanks!

-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>

