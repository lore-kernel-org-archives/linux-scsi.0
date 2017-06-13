From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 00/17] lpfc updates for 11.4.0.0
Date: Mon, 12 Jun 2017 23:04:51 -0400
Message-ID: <yq1shj4y4do.fsf@oracle.com>
References: <20170602040711.21046-1-jsmart2021@gmail.com>
        <yq14lvtex4v.fsf@oracle.com>
        <bd39df43-3f6c-c799-37a7-ede5790540d8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18821 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751753AbdFMDE4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2017 23:04:56 -0400
In-Reply-To: <bd39df43-3f6c-c799-37a7-ede5790540d8@gmail.com> (James Smart's
        message of "Tue, 6 Jun 2017 21:20:08 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org


Hi James,

>> We're approaching rc5 and there are several hundred-liners in this
>> submission. The EQ delay logic patch in particular looks like a feature
>> rather than a bug fix.
>>
>> How many of these are critical to get into 4.12 vs. 4.13?
>>

> All others I'd like to get in 4.12

This really looks way too big to be able to fly under the emperor
penguin's radar for rc6. We should be down to 10-liner patches at this
point in the stabilization window.

I have queued the whole series for 4.13. If there are smaller, trivial
patches without dependencies you would like to see in 4.12 I can shuffle
them over. 10, 11, and 12 appear to fix panics and are thus candidates
for rc6. Whereas "Add nvme initiator devloss support", while obviously a
deficiency, falls pretty clearly in the new feature bucket.

-- 
Martin K. Petersen	Oracle Linux Engineering
