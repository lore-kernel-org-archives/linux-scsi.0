From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bfa: do not dereference port before it is null checked
Date: Fri, 02 Sep 2016 06:10:39 -0400
Message-ID: <yq1y43atxwg.fsf@sermon.lab.mkp.net>
References: <20160830163616.11410-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42399 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752768AbcIBKKy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2016 06:10:54 -0400
In-Reply-To: <20160830163616.11410-1-colin.king@canonical.com> (Colin King's
        message of "Tue, 30 Aug 2016 17:36:16 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Colin" == Colin King <colin.king@canonical.com> writes:

Colin> port is deferenced before it is null sanity checked, hence we
Colin> potentially have a null pointer dereference bug. Instead,
Colin> initialise trl_enabled from port->fcs->bfa after we are sure port
Colin> is not null.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
