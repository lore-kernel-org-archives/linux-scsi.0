From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: nsp32: Remove unnecessary self assignment in nsp32_set_sync_entry
Date: Tue, 29 Jan 2019 01:27:48 -0500
Message-ID: <yq1womoc717.fsf@oracle.com>
References: <20181210235156.6237-1-natechancellor@gmail.com>
        <20190126191143.GB25003@archlinux-ryzen>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190126191143.GB25003@archlinux-ryzen> (Nathan Chancellor's
        message of "Sat, 26 Jan 2019 12:11:43 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: GOTO Masanori <gotom@debian.or.jp>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Nathan,

>> drivers/scsi/nsp32.c:2444:14: warning: explicitly assigning value of
>> variable of type 'unsigned char' to itself [-Wself-assign]
>>         offset      = offset;
>>         ~~~~~~      ^

Applied to 5.1/scsi-queue. Thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
