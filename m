From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ipr: Add asynchronous error notification
Date: Thu, 18 Aug 2016 22:47:53 -0400
Message-ID: <yq1twehh3ty.fsf@sermon.lab.mkp.net>
References: <1469795977-6345-1-git-send-email-halves@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43204 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754323AbcHSCsB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Aug 2016 22:48:01 -0400
In-Reply-To: <1469795977-6345-1-git-send-email-halves@linux.vnet.ibm.com>
        (Heitor Ricardo Alves de Siqueira's message of "Fri, 29 Jul 2016
        09:39:37 -0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heitor Ricardo Alves de Siqueira <halves@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Heitor Ricardo Alves de Siqueira <hrasiq@gmail.com>, Brian King <brking@linux.vnet.ibm.com>, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

>>>>> "Heitor" == Heitor Ricardo Alves de Siqueira <halves@linux.vnet.ibm.com> writes:

Heitor> This patch implements functions for pushing HCAM (host
Heitor> controlled asynchronous messages) error buffers to userspace
Heitor> through sysfs attributes.  Reads to the "async_err_log"
Heitor> attribute will result in a single HCAM buffer being copied to
Heitor> userspace; one can process the next HCAM buffer by writing any
Heitor> string to the same attribute.

Heitor> A new list was added to the ioa_cfg structure to store the HCAM
Heitor> buffers for later reporting. We also send a KOBJ_CHANGE event
Heitor> whenever a new HCAM buffer is made available to userspace.

Brian?

-- 
Martin K. Petersen	Oracle Linux Engineering
