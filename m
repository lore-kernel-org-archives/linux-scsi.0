From: "Dupuis, Chad" <chad.dupuis@hp.com>
Subject: Debug out from SCSI layers
Date: Thu, 3 Feb 2005 15:28:29 -0500
Message-ID: <A8B003DDA3332A479C0ECCA641F47E6503BE7087@tayexc13.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Received: from mailout.zma.compaq.com ([161.114.64.105]:8722 "EHLO
	zmamail05.zma.compaq.com") by vger.kernel.org with ESMTP
	id S263725AbVBCU2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2005 15:28:30 -0500
Received: from tayexg12.americas.cpqcorp.net (tayexg12.americas.cpqcorp.net [16.103.130.127])
	by zmamail05.zma.compaq.com (Postfix) with ESMTP id CCF22B9AA
	for <linux-scsi@vger.kernel.org>; Thu,  3 Feb 2005 15:28:29 -0500 (EST)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Is there a way to make the SCSI layers (midlayer, sd, etc.) print out a
some debug output to /var/log/messages so that one can see what's going
on in those driver real time?

Thanks,
Chad
