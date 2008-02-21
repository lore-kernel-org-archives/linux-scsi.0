From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: New sparse warning in lpfc_sli.c
Date: Wed, 20 Feb 2008 23:30:19 -0800
Message-ID: <1203579019.20345.8.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:48014 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbYBUHaH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Feb 2008 02:30:07 -0500
Received: by py-out-1112.google.com with SMTP id u52so3586327pyb.10
        for <linux-scsi@vger.kernel.org>; Wed, 20 Feb 2008 23:30:04 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James, somewhere between 2.6.25-rc1 and -rc2 this new warning appeared, care
to give the locking a quick once-over here?

drivers/scsi/lpfc/lpfc_sli.c:645:1: warning: context imbalance in 'lpfc_sli_hbqbuf_fill_hbqs' - wrong count at exit

Full log available if you want it.

Harvey

