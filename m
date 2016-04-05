From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/8] snic: LUN goes offline due to scsi cmd timeouts
Date: Mon, 04 Apr 2016 22:05:54 -0400
Message-ID: <yq18u0sdd31.fsf@sermon.lab.mkp.net>
References: <1458201077-10211-1-git-send-email-nmusini@cisco.com>
	<1458201077-10211-2-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38752 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932543AbcDECHG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2016 22:07:06 -0400
In-Reply-To: <1458201077-10211-2-git-send-email-nmusini@cisco.com> (Narsimhulu
	Musini's message of "Thu, 17 Mar 2016 00:51:11 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hare@suse.de, Sesidhar Baddela <sebaddel@cisco.com>

>>>>> "Narsimhulu" == Narsimhulu Musini <nmusini@cisco.com> writes:

Narsimhulu> - LUN goes offline, if there are atleast two scsi command
Narsimhulu> timeouts Completing the IO with scsi_done() fixes the issue.

Narsimhulu> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Narsimhulu> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com> ---
Narsimhulu> drivers/scsi/snic/snic_scsi.c | 18 ++++++++++++++++++ 1 file
Narsimhulu> changed, 18 insertions(+)

Applied patches 1-8 to to 4.7/scsi-queue.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
