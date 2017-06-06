From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: remove writeq/readq function definitions
Date: Mon, 05 Jun 2017 20:49:42 -0400
Message-ID: <yq1h8zudjo9.fsf@oracle.com>
References: <20170602113225.24816-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46028 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751192AbdFFAtx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2017 20:49:53 -0400
In-Reply-To: <20170602113225.24816-1-clabbe.montjoie@gmail.com> (Corentin
        Labbe's message of "Fri, 2 Jun 2017 13:32:25 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Corentin,

> Instead of rewriting write/readq, use linux/io-64-nonatomic-lo-hi.h
> which already have them.

Applied to 4.13/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
