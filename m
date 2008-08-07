From: Bernd Schubert <bs@q-leap.de>
Subject: WWNs, WWNN and WWPNs
Date: Thu, 7 Aug 2008 10:59:54 +0200
Message-ID: <200808071059.54959.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:55134 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758009AbYHGNIi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2008 09:08:38 -0400
Received: from lanczos (lanczos [192.168.55.86])
	by mail.q-leap.de (Postfix) with ESMTP id 7A89914DC
	for <linux-scsi@vger.kernel.org>; Thu,  7 Aug 2008 10:59:55 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

as far as I know only some hardware drivers can read these FC and SAS IDs, but 
these numbers are then never assigned in sysfs to the devices, but are if at 
all only linked to the HBA devices.

Are there specs available how to read the WWN, WWNN and WWPN ids?


Thanks,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
