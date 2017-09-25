From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Make use of UFS_BIT macro wherever possible
Date: Mon, 25 Sep 2017 15:31:16 -0400
Message-ID: <yq160c6h8xn.fsf@oracle.com>
References: <CGME20170828122625epcas2p33e3e912339c1e29051ad8e28251ea91b@epcas2p3.samsung.com>
        <1503922783-14317-1-git-send-email-alim.akhtar@samsung.com>
        <1503935147.2841.25.camel@wdc.com>
        <e26087fe-5e1b-c103-668d-43818765d3c9@samsung.com>
        <CAGOxZ52N=NLCZndc+sS1ym4zsdutk3keBv31-KNwe1u1bEfreg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGOxZ52N=NLCZndc+sS1ym4zsdutk3keBv31-KNwe1u1bEfreg@mail.gmail.com>
        (Alim Akhtar's message of "Mon, 11 Sep 2017 08:14:37 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@gmail.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Arnd Bergmann <arnd@arndb.de>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org


Alim,

> Should I drop this patch and send another one which removes UFS_BIT()
> macro?

I fail to see the point of UFS_BIT(). So yes.

Please make sure to CC: Subhash on ufs changes.

-- 
Martin K. Petersen	Oracle Linux Engineering
