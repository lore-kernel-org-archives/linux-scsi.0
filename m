From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2] scsi: ufs: revamp string descriptor reading
Date: Wed, 07 Aug 2019 21:41:40 -0400
Message-ID: <yq15zn8e8mj.fsf@oracle.com>
References: <20190730055517.32525-1-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190730055517.32525-1-tomas.winkler@intel.com> (Tomas Winkler's
        message of "Tue, 30 Jul 2019 08:55:17 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Avri Altman <Avri.Altman@wdc.com>, Alim Akhtar <alim.akhtar@samsung.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Alex Lemberg <Alex.Lemberg@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Tomas,

> Define new a type: uc_string_id for easier string handling and less
> casting. Reduce number or string copies in price of a dynamic
> allocation.

Applied to 5.4/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
