From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] aic7xxx: fix firmware build with O=path
Date: Mon, 24 Jul 2017 22:07:17 -0400
Message-ID: <yq1mv7t1d7u.fsf@oracle.com>
References: <20170719015834.19397-1-jakub.kicinski@netronome.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38807 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753098AbdGYCH1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2017 22:07:27 -0400
In-Reply-To: <20170719015834.19397-1-jakub.kicinski@netronome.com> (Jakub
        Kicinski's message of "Tue, 18 Jul 2017 18:58:34 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org


Jakub,

> Building firmware with O=path was apparently broken in aic7 for ever.
> Message of the previous commit to the Makefile (from 2008) mentions
> this unfortunate state of affairs already.  Fix this, mostly to make
> randconfig builds more reliable.

Applied to 4.13/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
