From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: DIF/DIX updates for 2.6.32
Date: Fri,  4 Sep 2009 04:36:29 -0400
Message-ID: <1252053394-24886-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:43729 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606AbZIDIgi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2009 04:36:38 -0400
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by rgminet12.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n848aSqk010375
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 4 Sep 2009 08:36:29 GMT
Received: from abhmt010.oracle.com (abhmt010.oracle.com [141.146.116.19])
	by acsinet15.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n848afLq007348
	for <linux-scsi@vger.kernel.org>; Fri, 4 Sep 2009 08:36:41 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Updates to DIF/DIX for 2.6.32.  Only changes since last post are:

 - Add a flag to control deallocation of 32-byte CDBs

 - Removed stray BUG_ON() in sd.c


