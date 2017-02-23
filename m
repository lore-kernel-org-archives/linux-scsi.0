From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] cciss: correct check map error.
Date: Thu, 23 Feb 2017 17:11:01 -0500
Message-ID: <yq1k28g5zii.fsf@oracle.com>
References: <148786184061.27650.6500371273219073720.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44657 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751284AbdBWWLJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Feb 2017 17:11:09 -0500
In-Reply-To: <148786184061.27650.6500371273219073720.stgit@brunhilda> (Don
        Brace's message of "Thu, 23 Feb 2017 08:57:20 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: scott.teel@microsemi.com, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:

Don> remove device driver failed to check map error messages

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
