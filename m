From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aacraid: error: testing array offset 'bus' after use
Date: Fri, 15 Sep 2017 21:46:34 -0400
Message-ID: <yq1r2v7s9dx.fsf@oracle.com>
References: <abd8be3220061294f53ed45a7487f9ea95f7aaac.1505292255.git.npajkovsky@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <abd8be3220061294f53ed45a7487f9ea95f7aaac.1505292255.git.npajkovsky@suse.cz>
        (Nikola Pajkovsky's message of "Wed, 13 Sep 2017 10:46:17 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Nikola Pajkovsky <npajkovsky@suse.cz>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Nikola,

> Fix possible indexing array of bound for &aac->hba_map[bus][cid],
> where bus and cid boundary check happens later.

Applied to 4.14/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
