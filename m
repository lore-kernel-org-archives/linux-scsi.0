From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 0/6] iscsi bug fixes for 2.6.31-rc
Date: Mon, 13 Jul 2009 22:28:05 -0500
Message-ID: <4A5BFB45.50004@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54728 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbZGND2P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jul 2009 23:28:15 -0400
Received: from [20.15.0.9] (c-75-73-66-60.hsd1.mn.comcast.net [75.73.66.60])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id n6E3SAZm016192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2009 22:28:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

The following patches were made over scsi-fix-fixes. They fix bugs in 
libiscsi and qla4xxx. Please apply for the next 2.6.31-rc if they are ok.
