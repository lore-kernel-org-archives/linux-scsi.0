From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: [PATCH 0/2] scsi_dh_alua fixes for NetApp E-Series Storage
Date: Mon, 14 Oct 2013 22:24:34 +0000
Message-ID: <8255ED565A0EAA4A960625E27D49DBF24AC14D49@SACEXCMBX04-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:38024 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab3JNWYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Oct 2013 18:24:36 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hare@suse.de" <hare@suse.de>

This short patch series fixes a couple of issues found while testing the scsi_dh_alua 
handler with NetApp E-Series storage, both of which would prevent the handler from 
attaching, even though TPGS is enabled. This has been observed to lead to some paths 
using the alua handler, some paths using the rdac handler.

Sean Stewart (2):
  ALUA check sense should retry device internal reset unit attention
  ALUA handler attach should succeed while TPG is transitioning

 drivers/scsi/device_handler/scsi_dh_alua.c | 31 ++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

-- 
1.8.3.1

