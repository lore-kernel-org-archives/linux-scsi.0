From: "Surekha.PC" <surekhap@cisco.com>
Subject: Sysfs does not recognise tape devices ?
Date: Wed, 5 Nov 2003 17:55:19 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <018f01c3a397$e093d600$a0074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:24150 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S262855AbTKEMZ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Nov 2003 07:25:28 -0500
Received: from samrat.cisco.com (samrat.cisco.com [192.135.241.21])
	by india-msg-core-1.cisco.com (8.12.9/8.12.6) with ESMTP id hA5Hr20s029206
	for <linux-scsi@vger.kernel.org>; Wed, 5 Nov 2003 17:53:05 GMT
Received: from surekhapw2k (dhcp-10-77-7-160.cisco.com [10.77.7.160])
	by samrat.cisco.com (8.8.8/2.6/Cisco List Logging/8.8.8) with ESMTP id RAA07995
	for <linux-scsi@vger.kernel.org>; Wed, 5 Nov 2003 17:55:24 +0530 (IST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

I have a iSCSI setup with scsi disk and tape configured as iSCSI
targets. The disks are recognised with sysfs, but tape device entries
are not getting created.

Is this a bug in sysfs?

TIA,
surekha

