From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 0/6] iscsi update
Date: Thu, 18 May 2006 20:31:28 -0500
Message-ID: <1148002288.3248.20.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59012 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932164AbWESBbu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 21:31:50 -0400
Received: from [192.168.0.4] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k4J1VT9v007190
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 20:31:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches are mostly bugfixes. Among them we fix a couple
memory usage problems and fix some eh problems. We also add support for
multiple daemons to be able to hook into the class.

The patches were made against scsi-misc.

