From: "Surekha.PC" <surekhap@cisco.com>
Subject: iSCSI HBA needs to have a unique host id
Date: Fri, 14 Nov 2003 15:26:36 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <009d01c3aa95$9d613b70$a0074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:13244 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S262310AbTKNJ4z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 04:56:55 -0500
Received: from samrat.cisco.com (samrat.cisco.com [192.135.241.21])
	by india-msg-core-1.cisco.com (8.12.9/8.12.6) with ESMTP id hAEFOP0s002976
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2003 15:24:29 GMT
Received: from surekhapw2k (dhcp-10-77-7-160.cisco.com [10.77.7.160])
	by samrat.cisco.com (8.8.8/2.6/Cisco List Logging/8.8.8) with ESMTP id PAA00907
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2003 15:26:41 +0530 (IST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi all,

   The host id for iSCSI HBA does not remain unique with  2.6 linux
kernel. It keeps changing when iSCSI host is added and removed
dynamically. This is a problem for persistent device naming for iSCSI
devices through host id.

It would be good to maintain a database of already allocated host id's
for the existing hosts. This would render the iSCSI HBA to get the same
controller id, irrespective of loading/unloading the driver repeatedly.
 
Would like to know if there is any provision in 2.6 to achieve the
above?

thanks,
surekha 

