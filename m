From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [PATCH] remove qla_hostlist
Date: Thu, 13 May 2004 07:57:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060EE8E@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:25026 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S264236AbUEMO6M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 10:58:12 -0400
Content-Class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Thursday, May 13, 2004 2:11 AM, Christoph Hellwig wrote:
> it's only used in proc_info currently and there we already have a
> scsi_host as argument anyway. 
>

Actually it's used in the failover codepaths (obviously not present
in the embedded driver) of the full distribution.  I'll surround its
uses with #ifdefs CONFIG_SCSI_QLA2XXX_FAILOVER, so that it's removed 
during our pre-processing routine.

James, please apply.

Thanks,
Andrew Vasquez
