From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] 3w-xxxx: pass through compat mode ioctls
Date: Thu, 7 Jan 2016 22:32:29 -0600
Message-ID: <BCFB53F5-420E-4AD3-9DF7-B4EF39A0587A@linux.vnet.ibm.com>
References: <1451022327-26943-1-git-send-email-nemesis@icequake.net>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:59072 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbcAHEcf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2016 23:32:35 -0500
Received: from localhost
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 7 Jan 2016 21:32:35 -0700
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 9F00A3E40030
	for <linux-scsi@vger.kernel.org>; Thu,  7 Jan 2016 21:32:32 -0700 (MST)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u084WWeV26017824
	for <linux-scsi@vger.kernel.org>; Fri, 8 Jan 2016 04:32:32 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u084WVYJ004454
	for <linux-scsi@vger.kernel.org>; Thu, 7 Jan 2016 23:32:32 -0500
In-Reply-To: <1451022327-26943-1-git-send-email-nemesis@icequake.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ryan C. Underwood" <nemesis@icequake.net>
Cc: Adam Radford <linuxraid@lsi.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com> 

