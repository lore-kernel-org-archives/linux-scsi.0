From: Amit Uttamchandani <auttamchandani@logicube.com>
Subject: Backporting 'libsas: fix timeout vs completion race' and related
 patches to 3.2.51 recommended?
Date: Fri, 25 Oct 2013 17:47:24 -0700
Message-ID: <20131026004724.GA18880@amit-debian.lg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c12o141.mxlogic.net ([208.65.145.64]:38282 "EHLO
	p01c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab3JZAyU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2013 20:54:20 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dan.j.williams@intel.com

Hello,

Tested kernel 3.4.62, which introduces:

 libsas error handling + discovery patch set

 http://lwn.net/Articles/476986/

Is it advisable for me to backport this to v3.2.51?

Thanks,
Amit
