From: Krishna Murthy <krmurthy@cisco.com>
Subject: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Thu, 23 Oct 2003 17:34:10 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200310231734.10263.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:23864 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S263561AbTJWMEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Oct 2003 08:04:34 -0400
Received: from krmurthy1-lnx.cisco.com (krmurthy1-lnx.cisco.com [10.77.7.60])
	by india-msg-core-1.cisco.com (8.12.9/8.12.6) with ESMTP id h9NHWCGX005896
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2003 17:32:14 GMT
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: davmyers@cisco.com

Hi,
	Linux iSCSI driver 4.0.0.1 (linux-iscsi-4.0.0.1.tgz) is available at

http://sf.net/projects/linux-iscsi/

	 Could you please review the same and let us know whether it is OK for 
inclusion into the linux 2-6 kernel?

The following are the changes w.r.t  version 3.4 of our driver which we 
had earlier sent for review:
 1)Compatible with linux -2.6.0 kernel. 
 2)Review comments from linux-scsi have been incorporated:
     - Indentation /Coding style has been taken care of.
     - Device probing and /dev/iscsi links creation have been moved from
	kernel to user mode.
     - linked list macros from list.h is being used now.
     -few of our kernel files were including <endian.h>. This has been 
rectified.



Thanx
N.C.Krishna Murthy
