From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] aacraid: Fix potential null access
Date: Wed, 15 Mar 2017 18:55:57 -0400
Message-ID: <yq1pohigneq.fsf@oracle.com>
References: <20170314162019.716-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51532 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753512AbdCOW4U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2017 18:56:20 -0400
In-Reply-To: <20170314162019.716-1-RaghavaAditya.Renukunta@microsemi.com>
        (Raghava Aditya Renukunta's message of "Tue, 14 Mar 2017 09:20:19
        -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Tomas Henzl <thezl@redhat.com>

Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com> writes:

> Currently command threads fails to return ioctls commands for older
> controller versions, since it returns when all the fibs have been
> allocated. Another issue is even all the fibs have not been allocated,
> the correct allocated fibs is not updated nor freed.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
