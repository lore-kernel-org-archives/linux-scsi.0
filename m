From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/12] scsi_debug: multiple queue support and cleanup
Date: Fri, 29 Apr 2016 19:53:06 -0400
Message-ID: <yq1d1p89dlp.fsf@sermon.lab.mkp.net>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26211 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbcD2XxT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Apr 2016 19:53:19 -0400
In-Reply-To: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
	(Douglas Gilbert's message of "Mon, 25 Apr 2016 12:16:27 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> Primary reason for this patch series is to add multi queue support
Doug> modelled on the null_blk driver. Ignore host_lock option but keep
Doug> parameter for backward compatibility. Use high resolution timers
Doug> to implement both the jiffy and nanosecond delay
Doug> parameters. Replace the tasklets with work items. Incorporate
Doug> REPORT LUNS patch from Tomas Winkler sent in Febrary 2015. Add
Doug> parameter that permits LU names to use UUIDs (spc5r08.pdf).

I applied 1-7 with minor fixes based on the comments. Sounds like 8 and
9 need a bit of tweaking. 10-12 look fine but don't apply out of order.

-- 
Martin K. Petersen	Oracle Linux Engineering
