From: Jamie Lenehan <lenehan@twibble.org>
Subject: ANNOUNCE - DC315/DC395 driver for 2.5
Date: Wed, 23 Apr 2003 17:27:37 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030423072737.GA5529@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charon.twibble.org ([203.217.29.134]:60298 "EHLO
	egwene.twibble.org") by vger.kernel.org with ESMTP id S263973AbTDWHPg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Apr 2003 03:15:36 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: dc395x@twibble.org
Cc: linux-scsi@vger.kernel.org

Hello all,
an updated version of the TekRam DC395/DC315 SCSI driver for the 2.5
kernels is available from:

  http://twibble.org/dist/dc395x/

Comments, suggestions and patches will be appreciated! The aim is to
try and get this driver integrated into the main kernel tree.

This driver is based on the original 2.4 driver with updates for 2.5
from various people merged in and a lot of cleanups done. No one has
been unable to contact Kurt Garloff, the previous maintainer of the
driver, for a long time and so have decided to maintain the driver
ourselves.

-- 
 Jamie Lenehan              Work Phone: +61 3 9843 8817
 lenehan@twibble.org        Work Email: jamie.lenehan@activcard.com.au
