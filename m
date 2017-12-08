From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] SCSI device blacklist handling improvements
Date: Thu, 07 Dec 2017 20:10:22 -0500
Message-ID: <yq1d13qvxc1.fsf@oracle.com>
References: <20171204183633.32139-1-bart.vanassche@wdc.com>
        <yq1k1xzxpk1.fsf@oracle.com> <1512668081.2624.24.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54494 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752078AbdLHBK2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2017 20:10:28 -0500
In-Reply-To: <1512668081.2624.24.camel@wdc.com> (Bart Van Assche's message of
        "Thu, 7 Dec 2017 17:34:43 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


Bart,

> Are you perhaps referring to the five __force casts? If so, do you
> have a suggestion for avoiding that sparse reports false positive
> warnings on the conversions between int and blist_flags_t? The only
> approach I can think of to reduce the number of __force casts is to
> embed these __force casts into two helper functions - one for the
> conversion from int to blist_flags_t and one for the conversion the
> other way around.

blist_flags_t is an unsigned int, you are forcing it to u32 two
places. That's a problem waiting to happen next time we add a blacklist
flag.

-- 
Martin K. Petersen	Oracle Linux Engineering
