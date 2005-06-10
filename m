From: Christoph Hellwig <hch@infradead.org>
Subject: support for old megaraid cards in megraid_mbox
Date: Sat, 11 Jun 2005 00:11:03 +0100
Message-ID: <20050610231103.GA17504@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:23778 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261402AbVFJXLL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 19:11:11 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sreenib@lsil.com, sju@lsil.com
Cc: linux-scsi@vger.kernel.org

is there a technical reason the PCI_DEVICE_ID_AMI_MEGARAID and
PCI_DEVICE_ID_AMI_MEGARAID2 cards are supported in the old
megraid driver, but not in megaraid_mbox?  It would be a real
pain to keep the old driver around just for those two cards.

