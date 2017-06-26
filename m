From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: don't include <generated/utsrelease.h>
Date: Mon, 26 Jun 2017 13:06:41 -0400
Message-ID: <yq14lv27k66.fsf@oracle.com>
References: <20170621114005.29800-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31264 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdFZRGr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 13:06:47 -0400
In-Reply-To: <20170621114005.29800-1-johannes@sipsolutions.net> (Johannes
        Berg's message of "Wed, 21 Jun 2017 13:40:05 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-scsi@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>


Johannes,

> There's no need to use the static UTS_RELEASE string, since
> utsname()->release contains the same.
>
> This avoids rebuilding this file for every change of the
> release string.

Applied to 4.13/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
