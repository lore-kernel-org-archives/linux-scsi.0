From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: Limit WRITE SAME / WRITE SAME(16) w/UNMAP length for certain devices
Date: Wed, 27 Sep 2017 21:34:25 -0400
Message-ID: <yq1fub7a9ni.fsf@oracle.com>
References: <1505837661-2280-1-git-send-email-emilne@redhat.com>
        <yq1wp4mcjvi.fsf@oracle.com>
        <1506529677.4100.452.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51048 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751881AbdI1Bed (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2017 21:34:33 -0400
In-Reply-To: <1506529677.4100.452.camel@localhost.localdomain> (Ewan
        D. Milne's message of "Wed, 27 Sep 2017 12:27:57 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Frederick.Knight@netapp.com


Ewan,

>> The spec is crystal clear. The device needs to be fixed. We can
>> blacklist older firmware revs.
>
> Yes, I know that is what SBC-4 says, and I agree that the devices
> are not conforming.  Unfortunately, I've come across 3 different
> arrays now from 3 different manufacturers that exhibit this behavior.

My main beef with your approach is that it penalizes devices that
actually implement the spec correctly.

I'll send a proposed patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
