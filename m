From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] virtio_scsi: Reject commands when virtqueue is broken
Date: Fri, 20 Jan 2017 19:18:52 -0500
Message-ID: <yq1wpdpgt8z.fsf@oracle.com>
References: <1484329686-21553-1-git-send-email-farman@linux.vnet.ibm.com>
        <1484329686-21553-2-git-send-email-farman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34703 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752486AbdAUAS7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jan 2017 19:18:59 -0500
In-Reply-To: <1484329686-21553-2-git-send-email-farman@linux.vnet.ibm.com>
        (Eric Farman's message of "Fri, 13 Jan 2017 12:48:06 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Farman <farman@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, famz@redhat.com

>>>>> "Eric" == Eric Farman <farman@linux.vnet.ibm.com> writes:

Eric> In the case of a graceful set of detaches, where the
Eric> virtio-scsi-ccw disk is removed from the guest prior to the
Eric> controller, the guest behaves quite normally.  Specifically, the
Eric> detach gets us into sd_sync_cache to issue a Synchronize Cache(10)
Eric> command, which immediately fails (and is retried a couple of
Eric> times) because the device has been removed.  Later, the removal of
Eric> the controller sees two CRWs presented, but there's no further
Eric> indication of the removal from the guest viewpoint.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
