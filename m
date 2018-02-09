From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/3] scsi: aacraid: Multi controller Kdump IOP reset handling
Date: Fri, 09 Feb 2018 18:44:36 -0500
Message-ID: <yq13729vicb.fsf@oracle.com>
References: <20180207164058.29598-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47646 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753196AbeBIXth (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Feb 2018 18:49:37 -0500
In-Reply-To: <20180207164058.29598-1-RaghavaAditya.Renukunta@microsemi.com>
        (Raghava Aditya Renukunta's message of "Wed, 7 Feb 2018 08:40:55
        -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Scott.Benesh@microsemi.com, esc-teamarcdriversvl@microsemi.com


Raghava,

> During Kdump aacraid controller IOP reset is invoked, IOP reset
> takes approx 40 seconds to bring the controller back up and running.
> with timeout of 120 seconds and anything more than 2 controllers
> will cause kdump to timeout.
>
> This patchset implements a new reset mechanism called DropIO, that
> induces the fw to drop any pending IO in the fw and making the reset
> process quicker.

Applied to 4.17/scsi-queue. Thanks for rebasing!

-- 
Martin K. Petersen	Oracle Linux Engineering
