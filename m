From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH 4/10] fusion - removing target_id/bus_id from the VirtDevice structure
Date: Tue, 14 Mar 2006 09:14:09 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F36D926@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:14986 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751953AbWCNQO0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Mar 2006 11:14:26 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, hch@lst.de, mdr@sgi.com

It makes no sense in keeping the target_id and bus_id
in the VirtDevice structure, when it can be obtained
from the VirtTarget structure.  

In addition, this patch fix's couple compilation bugs 
in mptfc.c when MPT_DEBUG_FC is enabled. This
provided by Micheal Reed.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>
