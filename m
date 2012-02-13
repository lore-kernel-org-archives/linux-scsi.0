From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 1/5] isci: T10 DIF support
Date: Mon, 13 Feb 2012 12:14:31 -0500
Message-ID: <yq1y5s6irk8.fsf@sermon.lab.mkp.net>
References: <20120210091814.26719.75603.stgit@dwillia2-linux.jf.intel.com>
	<20120210091834.26719.25785.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:43702 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275Ab2BMROh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2012 12:14:37 -0500
In-Reply-To: <20120210091834.26719.25785.stgit@dwillia2-linux.jf.intel.com>
	(Dan Williams's message of "Fri, 10 Feb 2012 01:18:34 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Dan" == Dan Williams <dan.j.williams@intel.com> writes:

Dan> This allows the controller to do WRITE_INSERT and READ_STRIP for
Dan> SAS disks that support protection information. SAS disks must be
Dan> formatted with protection information to use this feature via
Dan> sg_format.

I have not been able to locate a suitable machine for testing. But the
way this patch hooks into SCSI looks correct.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
