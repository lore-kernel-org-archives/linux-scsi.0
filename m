From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [LSF/MM TOPIC] How SRP initiator performance has been improved via
 scsi-mq
Date: Wed, 14 Jan 2015 10:37:39 +0100
Message-ID: <54B638E3.3030406@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0071.outbound.protection.outlook.com ([157.56.110.71]:47872
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750980AbbANJxM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2015 04:53:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>

Recently it has been proposed to discuss how to add scsi-mq support in
the iSER initiator during the 2015 edition of the LSF/MM summit. In the
discussion that followed that proposal several questions were asked
about how scsi-mq support has been added in the SRP initiator driver,
which design choices have been made and which lessons have been learned.
Hence the proposal to add a topic to the LSF/MM schedule for reporting
how scsi-mq support has been added in the SRP initiator.

For the actual discussion see also Sagi Grimberg, [LSF/MM TOPIC] iSCSI
MQ adoption via MCS discussion, linux-scsi mailing list, January 7, 2015
(http://thread.gmane.org/gmane.linux.scsi/98199).

Christoph and Mike, if you would like to complement this topic with a
presentation about the scsi-mq core itself and/or integration of
multiqueue support in the device mapper multipath driver, I would
welcome this.

Bart.
