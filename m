From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/22] zfcp fixes and cleanups
Date: Mon, 07 Aug 2017 13:19:11 -0400
Message-ID: <yq13793b8j4.fsf@oracle.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22686 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751683AbdHGRTR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2017 13:19:17 -0400
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com> (Benjamin
        Block's message of "Fri, 28 Jul 2017 12:30:46 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org


Hi Benjamin,

> here is a series of (important) fixes and some additional cleanups for
> the zfcp driver. Our fixes are marked for stable accordingly.
>
> Patches 01 - 04 are cleanups and external patches (also cleanups) that we
>       & 13 - 22     had queued for quite some time now
>
> Patches 05 - 12 are driver fixes that are all marked for stable as well

Given the ordering, it's a bit unclear how you want me to apply these.

There are a bunch of fixes you labeled as "important" but they are not
at the beginning of the series. And I am not sure if these have
dependencies on the preceding cleanup patches?

If you have fixes you would like to get into 4.13, please post those
first as a separate series. And clearly indicate that that's the branch
you are aiming for.

If you are OK with everything going into 4.14, then let me know. In that
case you don't have to shuffle the patches around.

-- 
Martin K. Petersen	Oracle Linux Engineering
