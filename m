From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] scsi: aacraid: Multi controller Kdump IOP reset handling
Date: Tue, 06 Feb 2018 19:21:15 -0500
Message-ID: <yq1vaf93b0k.fsf@oracle.com>
References: <20180120010157.22674-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51726 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932106AbeBGAV0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 19:21:26 -0500
In-Reply-To: <20180120010157.22674-1-RaghavaAditya.Renukunta@microsemi.com>
        (Raghava Aditya Renukunta's message of "Fri, 19 Jan 2018 17:01:54
        -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>


Raghava,

> During Kdump aacraid controller IOP reset is invoked, IOP reset
> takes approx 40 seconds to bring the controller back up and running.
> with timeout of 120 seconds and anything more than 2 controllers
> will cause kdump to timeout.
>
> This patchset implements a new reset mechanism called DropIO, that
> induces the fw to drop any pending IO in the fw and making the reset
> process quicker.

This series doesn't apply to my impending 4.17/scsi-queue. Since the
latter won't exist until Linus releases rc1, please respin against
current linus/master and resubmit.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
