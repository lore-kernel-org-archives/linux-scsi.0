From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Debug scsi message in linux 4.19.31
Date: Sun, 24 Mar 2019 20:04:07 -0400
Message-ID: <yq15zs73jm0.fsf@oracle.com>
References: <624bbdbb24ad7db69be29956cbf14689fd003cdb.camel@gmx.com>
        <25d0ddcb-b603-6e0d-d512-b188813837bf@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <25d0ddcb-b603-6e0d-d512-b188813837bf@infradead.org> (Randy
        Dunlap's message of "Sun, 24 Mar 2019 09:18:58 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Hussam Al-Tayeb <ht990332@gmx.com>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org


Randy,

>> Mar 23 17:40:10 hades kernel: sd 0:0:0:0: [sda] Optimal transfer size 0
>> bytes < PAGE_SIZE (4096 bytes)

We're just trying to weed out the devices that report garbage in this
field. But of course none of the devices I tested with put 0 in there.

>> Does it really belong in an LTS kernel?

The patch does fix problems for devices that report a nonsensical
value. But it is a regression that it now prints a warning for devices
that don't report an optimal I/O size at all.

Sorry about that. Will fix tomorrow!

-- 
Martin K. Petersen	Oracle Linux Engineering
