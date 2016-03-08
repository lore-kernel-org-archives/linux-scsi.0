From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] be2iscsi: set the boot_kset pointer to NULL in case of failure
Date: Mon, 07 Mar 2016 21:03:56 -0500
Message-ID: <yq137s1zpwz.fsf@sermon.lab.mkp.net>
References: <1457084509-7368-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23792 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbcCHCEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2016 21:04:07 -0500
In-Reply-To: <1457084509-7368-1-git-send-email-mlombard@redhat.com> (Maurizio
	Lombardi's message of "Fri, 4 Mar 2016 10:41:49 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: jayamohan.kallickal@avagotech.com, ketan.mukadam@avagotech.com, sony.john@avagotech.com, linux-scsi@vger.kernel.org

>>>>> "Maurizio" == Maurizio Lombardi <mlombard@redhat.com> writes:

Maurizio,

Maurizio> In beiscsi_setup_boot_info(), the boot_kset pointer should be
Maurizio> set to NULL in case of failure otherwise an invalid pointer
Maurizio> dereference may occur later.

iscsi_boot_destroy_kset() checks before deref and the other use location
just checks to see whether it's NULL. Are there places in the core iSCSI
code that use this without checking?

No particular problem with your patch. Just trying to decide whether
it's 4.5 material or not...

-- 
Martin K. Petersen	Oracle Linux Engineering
