From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] pcmcia: Remove unnecessary parentheses
Date: Tue, 29 Jan 2019 01:29:42 -0500
Message-ID: <yq1sgxcc6y1.fsf@oracle.com>
References: <20181210235540.7039-1-natechancellor@gmail.com>
        <20190126191203.GC25003@archlinux-ryzen>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190126191203.GC25003@archlinux-ryzen> (Nathan Chancellor's
        message of "Sat, 26 Jan 2019 12:12:03 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Nathan,

>> drivers/scsi/pcmcia/nsp_cs.c:1137:27: warning: equality comparison with
>> extraneous parentheses [-Wparentheses-equality]
>>                 if ((tmpSC->SCp.Message == MSG_COMMAND_COMPLETE)) {
>>                      ~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~

Applied to 5.1/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
