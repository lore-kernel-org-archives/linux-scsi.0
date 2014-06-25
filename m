From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] scsi patch queue tree
Date: Wed, 25 Jun 2014 05:41:29 -0700
Message-ID: <20140625124129.GB19647@infradead.org>
References: <20140519140614.GA12183@infradead.org>
 <20140611120143.GA26071@infradead.org>
 <1402496254.2523.3.camel@dabdike.int.hansenpartnership.com>
 <20140611143128.GA30904@infradead.org>
 <20140624155238.GA27828@infradead.org>
 <20140624155348.GA30669@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44559 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbaFYMla (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 08:41:30 -0400
Content-Disposition: inline
In-Reply-To: <20140624155348.GA30669@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

And here are the for-3.16 driver changes:


----------------------------------------------------------------
Brian King (2):
      ibmvscsi: Abort init sequence during error recovery
      ibmvscsi: Add memory barriers for send / receive

Maurizio Lombardi (2):
      pm8001: Fix potential null pointer dereference and memory leak.
      bnx2fc: do not scan uninitialized lists in case of error.

Neil Horman (2):
      fc: ensure scan_work isn't active when freeing fc_rport
      bnx2fc: Improve stats update mechanism

Paolo Bonzini (2):
      virtio-scsi: avoid cancelling uninitialized work items
      virtio-scsi: fix various bad behavior on aborted requests

Quinn Tran (1):
      qla2xxx: Fix sparse warning in qla_target.c.

Reddy, Sreekanth (1):
      MAINTAINERS: Update LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI) maintainers Email IDs

Tomas Henzl (2):
      be2iscsi: add an missing goto in error path
      be2iscsi: remove potential junk pointer free

 MAINTAINERS                       |    9 +++++----
 drivers/scsi/be2iscsi/be_main.c   |    2 ++
 drivers/scsi/be2iscsi/be_mgmt.c   |    4 +---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   16 ++++------------
 drivers/scsi/bnx2fc/bnx2fc_io.c   |    2 ++
 drivers/scsi/ibmvscsi/ibmvscsi.c  |   13 ++++++++++++-
 drivers/scsi/pm8001/pm8001_init.c |   13 ++++++++++---
 drivers/scsi/qla2xxx/qla_target.c |   17 +++++++++++------
 drivers/scsi/qla2xxx/qla_target.h |    4 ++--
 drivers/scsi/scsi_transport_fc.c  |    1 +
 drivers/scsi/virtio_scsi.c        |   26 +++++++++++++++++++++++++-
 11 files changed, 75 insertions(+), 32 deletions(-)
