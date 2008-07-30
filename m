From: David Somayajulu <david.somayajulu@qlogic.com>
Subject: [PATCH 0/2] scsi:qla2xxx:netlink support for hba specific messages
Date: Wed, 30 Jul 2008 14:53:41 -0700
Message-ID: <1217454822.25166.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29966 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038AbYG3Vx7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 17:53:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: David Somayajulu <david.somayajulu@qlogic.com>, David Wagner <david.wagner@qlogic.com>

The following patches:
1. add support to the scsi/fc transport layers for handling HBA specific messages.
2. add code in qla2xxx driver to support management of QLA84xx via the infrastructure in item 1.
-david S.
