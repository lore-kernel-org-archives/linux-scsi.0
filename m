From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/4] sas transport class and mptsas updates
Date: Wed, 19 Oct 2005 20:00:56 +0200
Message-ID: <20051019180055.GA21488@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:28296 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751205AbVJSSBk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 14:01:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, Eric.Moore@lsil.com
Cc: linux-scsi@vger.kernel.org

This patchset adds support for PHY resets to the SAS transport class
and the mptsas drivers, aswell as various fixes.  The patches are ontop
of the following patches I submitted previously:

in scsi-rc-fixes:
  [PATCH] mptsas: fix phy identifiers

not included yet:
  [PATCH] scsi_transport_sas: support link error attributes
  [PATCH] mptsas: support link error attributes
