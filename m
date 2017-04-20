From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qedi,qedf: Use designated initializers
Date: Wed, 19 Apr 2017 22:11:26 -0400
Message-ID: <yq1o9vrrfox.fsf@oracle.com>
References: <20170329205923.GA39690@beast>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50879 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765596AbdDTCLg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2017 22:11:36 -0400
In-Reply-To: <20170329205923.GA39690@beast> (Kees Cook's message of "Wed, 29
        Mar 2017 13:59:23 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org


Kees,

> Prepare to mark sensitive kernel structures for randomization by
> making sure they're using designated initializers. These were
> identified during allyesconfig builds of x86, arm, and arm64, with
> most initializer fixes extracted from grsecurity.
>
> For these cases, terminate the list with { }, which will be
> zero-filled, instead of undesignated NULLs.

Applied to 4.12/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
