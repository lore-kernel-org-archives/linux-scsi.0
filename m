From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] mpt3sas - remove unused fw_event_work elements
Date: Mon, 25 Apr 2016 21:55:11 -0400
Message-ID: <yq1inz5i16o.fsf@sermon.lab.mkp.net>
References: <1460991012-10018-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48048 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbcDZBzc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2016 21:55:32 -0400
In-Reply-To: <1460991012-10018-1-git-send-email-joe.lawrence@stratus.com> (Joe
	Lawrence's message of "Mon, 18 Apr 2016 10:50:12 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Chaitra Basappa <chaitra.basappa@broadcom.com>

>>>>> "Joe" == Joe Lawrence <joe.lawrence@stratus.com> writes:

Joe> Firmware events are queued up using the fw_event_work's struct
Joe> work, not its delayed_work member.  The initial driver for SAS2
Joe> controllers had handled firmware reset using the rescan barrier and
Joe> was later redesigned through "mpt2sas: [Resend] Host Reset code
Joe> cleanup".  The delayed_work variables are now unused and may
Joe> provoke CONFIG_DEBUG_OBJECTS_TIMERS "assert_init not available"
Joe> false warnings in _scsih_fw_event_cleanup_queue.

Joe> Cleanup fw_event_work's unused entries, update it's kerneldoc, and
Joe> update _scsih_fw_event_cleanup_queue accordingly.

Applied to 4.7/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
