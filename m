From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: aacraid: Off by one NUL terminator
Date: Thu, 27 Jul 2017 08:55:58 -0400
Message-ID: <yq1inievy1t.fsf@oracle.com>
References: <20170725195110.uwrzzkzvrbfqv7ld@mwanda>
        <yq1wp6uwp9c.fsf@oracle.com> <20170727090035.iqqavxvuc6hntjhs@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170727090035.iqqavxvuc6hntjhs@mwanda> (Dan Carpenter's message
        of "Thu, 27 Jul 2017 12:00:35 +0300")
Sender: kernel-janitors-owner@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-scsi@vger.kernel.org


Dan,

> It would be simple enough to write it like you say, but it probably
> should be done by someone who is able to test it.

Indeed, I don't have any aacraid hw.

Raghava, could you please take a look at this issue?

	https://patchwork.kernel.org/patch/9863105/

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
