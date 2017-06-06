From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] m68k/atari: atari_scsi.c - use m68k_realnum_memory for FastRAM test
Date: Mon, 05 Jun 2017 20:55:27 -0400
Message-ID: <yq1d1aidjeo.fsf@oracle.com>
References: <1496648279-15702-1-git-send-email-schmitzmic@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48808 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751695AbdFFAz5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2017 20:55:57 -0400
In-Reply-To: <1496648279-15702-1-git-send-email-schmitzmic@gmail.com> (Michael
        Schmitz's message of "Mon, 5 Jun 2017 19:37:59 +1200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: linux-m68k@vger.kernel.org, fthain@telegraphics.com.au, geert@linux-m68k.org, cts@debian.org, linux-scsi@vger.kernel.org


Michael,

> m68k_num_memory is unsuitable to test for the presence of FastRAM on
> CT60 if the kernel is located in FastRAM: in arch/m68k/mm/motorola.c
> the ST-RAM chunk is skipped and m68k_num_memory is decremented in this
> case. m68k_realnum_memory still contains the actual number of RAM
> chunks so use that.

Applied to 4.13/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
