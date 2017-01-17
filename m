From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bfa: fix wrongly initialized variable in bfad_im_bsg_els_ct_request()
Date: Tue, 17 Jan 2017 14:04:01 -0500
Message-ID: <yq18tq9o6e6.fsf@oracle.com>
References: <20170110115436.15123-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26649 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbdAQTEP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2017 14:04:15 -0500
In-Reply-To: <20170110115436.15123-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Tue, 10 Jan 2017 12:54:36 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Nicolas Iooss <nicolas.iooss_linux@m4x.org>

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes> Commit 01e0e15c8b3b ("scsi: don't use fc_bsg_job::request and
Johannes> fc_bsg_job::reply directly") introduced a typo, which causes
Johannes> that the bsg_request variable in bfad_im_bsg_els_ct_request()
Johannes> is initialized to itself instead of pointing to the bsg job's
Johannes> request.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
