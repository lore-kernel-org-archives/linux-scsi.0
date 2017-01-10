From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: scsi: qla2xxx: Fix apparent cut-n-paste error.
Date: Mon, 09 Jan 2017 23:24:43 -0500
Message-ID: <yq160lnee44.fsf@oracle.com>
References: <20161227181321.35xf5hm4qz3uajmp@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45196 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751860AbdAJEY7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2017 23:24:59 -0500
In-Reply-To: <20161227181321.35xf5hm4qz3uajmp@codemonkey.org.uk> (Dave Jones's
        message of "Tue, 27 Dec 2016 13:13:21 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@codemonkey.org.uk>
Cc: linux-scsi@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>

>>>>> "Dave" == Dave Jones <davej@codemonkey.org.uk> writes:

Dave> commit 093df73771bac8a37d607c0e705d157a8cef4c5c introduces two
Dave> bodies of code that look similar but with s/req/rsp/ in the second
Dave> instance.  But in one case, it looks like this conversion was
Dave> missed.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
