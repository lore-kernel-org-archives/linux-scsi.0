From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fnic: use kzalloc in fnic_fcoe_process_vlan_resp
Date: Wed, 17 Jan 2018 00:55:12 -0500
Message-ID: <yq14lnluj0f.fsf@oracle.com>
References: <20180108231115.17459-1-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58336 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750815AbeAQFzU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2018 00:55:20 -0500
In-Reply-To: <20180108231115.17459-1-linux@rasmusvillemoes.dk> (Rasmus
        Villemoes's message of "Tue, 9 Jan 2018 00:11:15 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Karan Tilak Kumar <kartilak@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Rasmus,

> This saves a little .text and gets rid of the unmotivated line break and
> the sizeof(...) style inconsistency.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
