From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 00/29] be2iscsi: driver update 11.2.0.0
Date: Tue, 23 Aug 2016 22:44:08 -0400
Message-ID: <yq14m6aevif.fsf@sermon.lab.mkp.net>
References: <1471600226-22055-1-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:44846 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753294AbcHXDEp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Aug 2016 23:04:45 -0400
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u7O2jH8l010688
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2016 02:45:18 GMT
In-Reply-To: <1471600226-22055-1-git-send-email-jitendra.bhivare@broadcom.com>
        (Jitendra Bhivare's message of "Fri, 19 Aug 2016 15:19:57 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: linux-scsi@vger.kernel.org, mchristi@redhat.com

>>>>> "Jitendra" == Jitendra Bhivare <jitendra.bhivare@broadcom.com> writes:

Jitendra Bhivare (29):
  be2iscsi: Fix to use correct configuration values
  be2iscsi: Replace _bh version for mcc_lock spinlock
  be2iscsi: Reduce driver load/unload time
  be2iscsi: Set and return right iface v4/v6 states
  be2iscsi: Fix gateway APIs to support IPv4 & IPv6
  be2iscsi: Fix release of DHCP IP in static mode
  be2iscsi: Move VLAN code to common iface_set_param
  be2iscsi: Update iface handle before any set param
  be2iscsi: Rename iface get/set/create/destroy APIs
  be2iscsi: Handle only NET_PARAM in iface_get_param
  be2iscsi: Check all zeroes IP before issuing IOCTL
  be2iscsi: Remove alloc_mcc_tag & beiscsi_pci_soft_reset
  be2iscsi: Remove isr_lock and dead code
  be2iscsi: Fix checks for HBA in error state
  be2iscsi: Fix to make boot discovery non-blocking
  be2iscsi: Fix to add timer for UE detection
  be2iscsi: Add IOCTL to check UER supported
  be2iscsi: Move functions to right files
  be2iscsi: Fix POST check and reset sequence
  be2iscsi: Add V1 of EPFW cleanup IOCTL
  be2iscsi: Add TPE recovery feature
  be2iscsi: Fail the sessions immediately after TPE
  be2iscsi: Add FUNCTION_RESET during driver unload
  be2iscsi: Fix async PDU handling path
  be2iscsi: Fix bad WRB index error
  be2iscsi: Fix queue and connection parameters
  be2iscsi: Update copyright information
  be2iscsi: Update the driver version
  MAINTAINERS: Update be2iscsi contact info

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
