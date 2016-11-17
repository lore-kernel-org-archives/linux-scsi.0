From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] 53c700: fix memory leak of dma non-cosistent memory
Date: Wed, 16 Nov 2016 20:41:16 -0500
Message-ID: <yq1y40iannn.fsf@sermon.lab.mkp.net>
References: <582962db.0130ed0a.10866.5633@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17988 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932773AbcKQBlY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2016 20:41:24 -0500
In-Reply-To: <582962db.0130ed0a.10866.5633@mx.google.com> (Li Qiang's message
        of "Mon, 14 Nov 2016 15:07:58 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Li Qiang <liq3ea@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

>>>>> "Li" == Li Qiang <liq3ea@gmail.com> writes:

Li> In NCR_700_detect function, if an error occurs it will return NULL
Li> without freeing the dma non-cosistent memory once allocated.  This
Li> patch avoid this.

James: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
