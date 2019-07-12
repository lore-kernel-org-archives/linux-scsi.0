From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 2/2] scsi: aacraid: Remove references to Series-9 (only)
Date: Thu, 11 Jul 2019 21:30:07 -0400
Message-ID: <yq15zo86nvk.fsf@oracle.com>
References: <2a6f5cc2-40cb-647c-003d-aae594d05062@virtuozzo.com>
        <20190710093113.27936-1-khorenko@virtuozzo.com>
        <20190710093113.27936-3-khorenko@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190710093113.27936-3-khorenko@virtuozzo.com> (Konstantin
        Khorenko's message of "Wed, 10 Jul 2019 12:31:13 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Prasad B Munirathnam <prasad.munirathnam@microsemi.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, David Carroll <david.carroll@microsemi.com>, Finn Thain <fthain@telegraphics.com.au>, "Andrey Jr . Melnikov" <temnota.am@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@microsemi.com>
List-Id: linux-scsi@vger.kernel.org


Hi Konstantin,

> The patch removes references to Series 9 adapters following
> 395e5df79a95 ("scsi: aacraid: Remove reference to Series-9"),
> but doesn't touch Series 6 adapters logic.

We'll need some guidance from the Microsemi folks on this issue.

> https://bugzilla.redhat.com/show_bug.cgi?id=1724077
> https://jira.sw.ru/browse/PSBM-95736

These two links don't appear to be publicly accessible and therefore do
not belong in the patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
