From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid_sas: move command counter to correct place
Date: Tue, 08 Aug 2017 11:50:45 -0400
Message-ID: <yq11som83e2.fsf@oracle.com>
References: <20170728140359.15424-1-thenzl@redhat.com>
        <yq1lgmv9t51.fsf@oracle.com>
        <730abe70a796241670b9443bd72e395b@mail.gmail.com>
        <1502206757.2736.21.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24698 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbdHHPu6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2017 11:50:58 -0400
In-Reply-To: <1502206757.2736.21.camel@HansenPartnership.com> (James
        Bottomley's message of "Tue, 08 Aug 2017 08:39:17 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@broadcom.com>


James,

> Martin: this means my fixes branch got rebased; can you rebase your
> fixes branch on top of mine before we all get a beating from Stephen
> Rothwell because of a mismerge in linux-next due to the tree
> differences?

Done.

-- 
Martin K. Petersen	Oracle Linux Engineering
