From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] be2iscsi: set the boot_kset pointer to NULL in case of failure
Date: Tue, 08 Mar 2016 20:52:11 -0500
Message-ID: <yq1wppcwh84.fsf@sermon.lab.mkp.net>
References: <1457084509-7368-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20394 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbcCIBwW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2016 20:52:22 -0500
In-Reply-To: <1457084509-7368-1-git-send-email-mlombard@redhat.com> (Maurizio
	Lombardi's message of "Fri, 4 Mar 2016 10:41:49 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: jayamohan.kallickal@avagotech.com, ketan.mukadam@avagotech.com, sony.john@avagotech.com, linux-scsi@vger.kernel.org

>>>>> "Maurizio" == Maurizio Lombardi <mlombard@redhat.com> writes:

Maurizio> In beiscsi_setup_boot_info(), the boot_kset pointer should be
Maurizio> set to NULL in case of failure otherwise an invalid pointer
Maurizio> dereference may occur later.

Applied to 4.5/scsi-fixes.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
