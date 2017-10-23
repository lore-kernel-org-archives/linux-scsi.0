From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Added notes to scsi-parameters.txt to show how to pass parameters on kernel line
Date: Mon, 23 Oct 2017 03:44:02 -0400
Message-ID: <yq1376amhq5.fsf@oracle.com>
References: <1508422803-17361-1-git-send-email-loberman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51552 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750746AbdJWHoH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2017 03:44:07 -0400
In-Reply-To: <1508422803-17361-1-git-send-email-loberman@redhat.com> (Laurence
        Oberman's message of "Thu, 19 Oct 2017 10:20:03 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org


Laurence,

I ended up going a slightly different route. Instead of adding your
clarifying paragraph, I fixed the places where the module parameter was
incorrectly written (i.e. missing the scsi_mod. prefix).

-- 
Martin K. Petersen	Oracle Linux Engineering
