From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/20] lpfc: Update lpfc to revision 11.2.0.10
Date: Mon, 06 Mar 2017 23:09:02 -0500
Message-ID: <yq1d1dtk9sx.fsf@oracle.com>
References: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:44080 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932570AbdCGE6h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2017 23:58:37 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v274AY5a020406
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2017 04:10:34 GMT
In-Reply-To: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com> (jsmart's
        message of "Sat, 4 Mar 2017 09:30:20 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org

>>>>> "James" == jsmart2021  <jsmart2021@gmail.com> writes:

James,

James> This set of patches are mainly cleanups and fixes to the large
James> nvme post that was recently integrated. It includes a patch to
James> break the mandate for both NVME and SCSI subystems.

A couple of the patches in this series felt quite a bit bigger than "a
fix". I let them in because I acknowledge that it was a pretty big chunk
of code that just got merged and that some fallout was inevitable.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
