From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 0/3] clean gendisk out of scsi ULD structs
Date: Thu, 5 Jul 2007 14:06:36 -0700
Message-ID: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64298 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758239AbXGEVJy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jul 2007 17:09:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: akpm@linux-foundation.org, jeff@garzik.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Since gendisk will now become part of struct scsi_device, we don't need
to store this value in any private data structs where they already store
scsi_device.  This series cleans up a few drivers which did this.

Kristen

-- 
