From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: nsp32: fix logic bug in error handling
Date: Mon, 16 Oct 2017 22:39:34 -0400
Message-ID: <yq1wp3u1ord.fsf@oracle.com>
References: <20170905075139.518406-1-arnd@arndb.de>
        <CALZLnaF=ih9nC7dYusxwOKeYhGHa_mRy8k8gGOHpaUvyBkD2kA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALZLnaF=ih9nC7dYusxwOKeYhGHa_mRy8k8gGOHpaUvyBkD2kA@mail.gmail.com>
        (Masanori Goto's message of "Mon, 16 Oct 2017 08:51:22 +0900")
Sender: linux-kernel-owner@vger.kernel.org
To: Masanori Goto <gotom@debian.or.jp>
Cc: Arnd Bergmann <arnd@arndb.de>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Masanori,

>> gcc-8 points out a logic error that has existed since the start
>> of the git history:
>>
>> drivers/scsi/nsp32.c: In function 'nsp32_selection_autoscsi':
>> drivers/scsi/nsp32.c:607:27: error: bitwise comparison always evaluates to false [-Werror=tautological-compare]
>>   if(((phase & BUSMON_BSY) == 1) || (phase & BUSMON_SEL) == 1) {

Applied to 4.15/scsi-queue. Thanks, Arnd!

-- 
Martin K. Petersen	Oracle Linux Engineering
