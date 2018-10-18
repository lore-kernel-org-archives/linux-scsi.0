From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ips: fix missing break in switch
Date: Wed, 17 Oct 2018 21:01:01 -0400
Message-ID: <yq1tvlkkr02.fsf@oracle.com>
References: <20181016091223.GA19765@embeddedor.com>
        <yq1ftx5sgw1.fsf@oracle.com>
        <alpine.LNX.2.21.1810170922480.130@nippy.intranet>
        <yq1r2gppdyf.fsf@oracle.com>
        <alpine.LNX.2.21.1810171327290.8@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.21.1810171327290.8@nippy.intranet> (Finn Thain's
        message of "Wed, 17 Oct 2018 14:24:47 +1100 (AEDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Finn,

>> See the case statements above for another fast exit scenario.
>> 
>
> But that's an error path.

Look further down. Several other SCSI commands are completed as NOPs the
same way.

Also, I don't see how the case statement for TUR/INQUIRY would do
anything meaningful in terms of preparing a START STOP UNIT for the
firmware.

-- 
Martin K. Petersen	Oracle Linux Engineering
