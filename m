From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] Use blist_flags_t consistently
Date: Thu, 14 Dec 2017 22:33:04 -0500
Message-ID: <yq1zi6kmzrj.fsf@oracle.com>
References: <20171212182328.20088-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57524 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754718AbdLODj5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Dec 2017 22:39:57 -0500
In-Reply-To: <20171212182328.20088-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Tue, 12 Dec 2017 10:23:28 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>


Bart,

> Use the type blist_flags_t for all variables that represent blacklist
> flags. Additionally, suppress recently introduced sparse warnings
> related to blacklist flags.

Applied to 4.15/scsi-fixes, thanks!

PS. Had to tweak the commit ID.

-- 
Martin K. Petersen	Oracle Linux Engineering
