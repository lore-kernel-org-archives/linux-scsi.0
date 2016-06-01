From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] _scsih_sas_host_add early exits can crash system
Date: Tue, 31 May 2016 22:41:04 -0400
Message-ID: <yq18typwrzz.fsf@sermon.lab.mkp.net>
References: <1464203669-31974-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28930 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbcFAClT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2016 22:41:19 -0400
In-Reply-To: <1464203669-31974-1-git-send-email-joe.lawrence@stratus.com> (Joe
	Lawrence's message of "Wed, 25 May 2016 15:14:27 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com

>>>>> "Joe" == Joe Lawrence <joe.lawrence@stratus.com> writes:

Joe> There are many error paths in _scsih_sas_host_add that lead to an
Joe> early exit and a few that leave IOC resources uninitialized,
Joe> setting the stage for a later crash.

Applied to 4.8/scsi-queue.

Please make sure to use "mpt3sas: foo bar" in the patch
descriptions. You had used "mpt3sas - foo bar".

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
