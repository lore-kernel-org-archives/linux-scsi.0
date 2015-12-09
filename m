From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 0/3] hpsa update
Date: Wed, 09 Dec 2015 15:18:38 -0600
Message-ID: <20151209211816.519.50876.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:53579 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410AbbLIVXF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2015 16:23:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, james.bottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:
 - correct missing changes from snprintf to scnprintf
   in path_info_show by Rasmus Villemoes
 - fix reported bus for SAS transport devices
 - add in enclosure information

---

Don Brace (3):
      hpsa: fix path_info_show
      hpsa: change SAS transport devices to bus 0.
      hpsa: add box and bay information for enclosure devices


 drivers/scsi/hpsa.c     |  118 ++++++++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/hpsa.h     |    2 -
 drivers/scsi/hpsa_cmd.h |   13 +++++
 3 files changed, 120 insertions(+), 13 deletions(-)

--
Signature
