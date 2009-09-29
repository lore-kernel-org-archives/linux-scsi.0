From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCHv2 0/4] scsi: export and clean up headers
Date: Tue, 29 Sep 2009 12:33:53 +0200
Message-ID: <20090929103353.GA11183@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbZI2KgI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2009 06:36:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>, Sam Ravnborg <sam@ravnborg.org>

This implements a minor cleanup of exported scsi headers,
and adds export of headers that are de-facto used by userspace.
The patches are on top of 2.6.32-rc1.
Can these be queued for 2.6.32?
Thanks.


Michael S. Tsirkin (4):
  scsi: consistent use of __u8 in scsi/scsi.h
  scsi: make scsi/scsi.h headers_check clean
  scsi: export scsi_ioctl.h and sg.h headers
  scsi: export scsi_tgt_if.h

 include/scsi/Kbuild |    3 +++
 include/scsi/scsi.h |   12 ++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)
