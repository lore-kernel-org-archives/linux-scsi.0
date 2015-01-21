From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: sc_data_direction and bidi commands
Date: Wed, 21 Jan 2015 17:18:43 +0100
Message-ID: <54BFD163.4020802@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf1.bxl.stone.is ([87.238.167.36]:40667 "EHLO sf1.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbbAUQSx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2015 11:18:53 -0500
Received: from smtprelay.1eurohost.com ([87.238.167.34])
	by sf1.bxl.stone.is with esmtp (Exim 4.84)
	(envelope-from <bart.vanassche@sandisk.com>)
	id 1YDxzS-0006UR-Ln
	for linux-scsi@vger.kernel.org; Wed, 21 Jan 2015 17:18:51 +0100
Received: from vz19.stone-is.net (vz19.stone-is.net [87.238.162.57])
	by smtprelay.1eurohost.com (Postfix) with ESMTP id CCED522045C
	for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2015 17:18:44 +0100 (CET)
Received: from [192.168.1.119] (178-117-55-239.access.telenet.be [178.117.55.239])
	by vz19.stone-is.net (Postfix) with ESMTPSA id D03A32DC003
	for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2015 17:18:46 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello,

Although several SCSI LLDs compare sc_data_direction with the value
DMA_BIDIRECTIONAL apparently scsi_setup_cmnd() never sets
sc_data_direction to the value DMA_BIDIRECTIONAL. Is this behavior on
purpose ? I discovered this while debugging bidi support in a SCSI LLD.

Thanks,

Bart.
