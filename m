From: Alexander Nyberg <alexn@telia.com>
Subject: Some bad stack offenders
Date: Fri, 11 Jun 2004 13:56:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086954964.680.62.camel@boxen>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxfep02.bredband.com ([195.54.107.73]:14503 "EHLO
	mxfep02.bredband.com") by vger.kernel.org with ESMTP
	id S263851AbUFKL4G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2004 07:56:06 -0400
Received: from [192.168.0.127] ([213.113.37.206] [213.113.37.206])
          by mxfep02.bredband.com with ESMTP
          id <20040611115604.GZNU1450.mxfep02.bredband.com@[192.168.0.127]>
          for <linux-scsi@vger.kernel.org>; Fri, 11 Jun 2004 13:56:04 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

(please CC)

This in 2.6.7-rc3-mm1


./drivers/scsi/gdth.c
5f8 ioc_hdrlist
620 ioc_rescan


./drivers/scsi/cpqfcTScontrol.c
810 CpqTsProcessIMQEntry
804 PeekIMQEntry


./drivers/scsi/gdth_proc.c
434 gdth_get_info


Alex

