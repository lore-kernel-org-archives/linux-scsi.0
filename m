From: Dave Jones <davej@redhat.com>
Subject: self assignment bug in aix94xx
Date: Thu, 24 Oct 2013 04:55:12 -0400
Message-ID: <20131024085512.GB15720@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab3JXIzT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Oct 2013 04:55:19 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9O8tJi6001037
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 24 Oct 2013 04:55:19 -0400
Received: from gelk.kernelslacker.org (ovpn-113-141.phx2.redhat.com [10.3.113.141])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r9O8tDee007762
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 24 Oct 2013 04:55:19 -0400
Received: from gelk.kernelslacker.org (localhost [127.0.0.1])
	by gelk.kernelslacker.org (8.14.7/8.14.7) with ESMTP id r9O8tCMn016944
	for <linux-scsi@vger.kernel.org>; Thu, 24 Oct 2013 04:55:12 -0400
Received: (from davej@localhost)
	by gelk.kernelslacker.org (8.14.7/8.14.7/Submit) id r9O8tCYe016943
	for linux-scsi@vger.kernel.org; Thu, 24 Oct 2013 04:55:12 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

2908d778        (James Bottomley        2006-08-29 09:22:51 -0500       515)    scb->ssp_task.retry_count = scb->ssp_task.retry_count;

Is this supposed to maybe be..

	scb->ssp_task.retry_count = task->ssp_task.retry_count;

?

(This and a whole bunch of similar bugs found with Coverity.)

	Dave

