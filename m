From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 0/9] - fusion - 3.04.04
Date: Mon, 29 Jan 2007 09:39:18 -0700
Message-ID: <20070129163917.GA1860@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60337 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbXA2Qio (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jan 2007 11:38:44 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Patch Summary
--------------------------------------------------------------

scsilun_to_int - export symbol to be used in 1st fusion patch
spi_dv_pending - export define to be used in 3rd fusion patch

1 - Greater than 255 target and lun support
2 - move SPI API over to mptspi.c
3 - added mptspi debug
4 - iocstatus, loginfo, and event debug updates
5 - inactive raid support, and raid event bug fix's
6 - serialize target resets in mptsas.c
7 - report wide port sas address's for hba phys
8 - error handling bug fix's
9 - bump version

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>
