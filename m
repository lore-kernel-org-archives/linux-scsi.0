From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: nsp32: add __printf attribute to logging functions
Date: Tue, 23 May 2017 22:02:07 -0400
Message-ID: <yq11srfxba8.fsf@oracle.com>
References: <20170520111628.24787-1-nicolas.iooss_linux@m4x.org>
        <1495280136.27714.6.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35528 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751620AbdEXCCn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2017 22:02:43 -0400
In-Reply-To: <1495280136.27714.6.camel@perches.com> (Joe Perches's message of
        "Sat, 20 May 2017 04:35:36 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Nicolas Iooss <nicolas.iooss_linux@m4x.org>, GOTO Masanori <gotom@debian.or.jp>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Joe,

> On Sat, 2017-05-20 at 13:16 +0200, Nicolas Iooss wrote:
>> nsp32_message() and nsp32_dmessage() use printf format strings in order
>> to format a message. Adding __printf attributes helps to detect errors
>> in such format strings at build time, like:

> Does anyone actually have or use these cards any longer?

I doubt it.

-- 
Martin K. Petersen	Oracle Linux Engineering
