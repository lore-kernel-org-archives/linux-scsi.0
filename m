From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla4xxx: skip error recovery in case of register disconnect.
Date: Tue, 13 Feb 2018 21:35:55 -0500
Message-ID: <yq1d118pab8.fsf@oracle.com>
References: <20180212064841.24503-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39398 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966382AbeBNCgO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 21:36:14 -0500
In-Reply-To: <20180212064841.24503-1-manish.rangankar@cavium.com> (Manish
        Rangankar's message of "Sun, 11 Feb 2018 22:48:41 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Manish Rangankar <manish.rangankar@cavium.com>
Cc: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com, linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com


Manish,

> A system crashes when continuously removing/re-adding the storage
> controller.

Applied to 4.16/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
