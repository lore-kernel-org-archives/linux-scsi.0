From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v1 0/3] hpsa update
Date: Tue, 15 Dec 2015 09:57:47 -0600
Message-ID: <20151215155328.22855.56591.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:49135 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932282AbbLOP6a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Dec 2015 10:58:30 -0500
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

Changes from initial upload
 - added short patch description for patch
   hpsa-add-enclosure-connection-box-bay-information
 - kept hpsa-change-hba-controller-to-bus-0 the same to
   minimize changes.
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
