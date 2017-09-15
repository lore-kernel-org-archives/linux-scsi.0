From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: tc-dwc-g210: make arrays static, reduces object code size
Date: Fri, 15 Sep 2017 15:42:10 -0400
Message-ID: <yq1zi9voijx.fsf@oracle.com>
References: <20170912113228.1389-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170912113228.1389-1-colin.king@canonical.com> (Colin King's
        message of "Tue, 12 Sep 2017 12:32:28 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Joao Pinto <jpinto@synopsys.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> Don't populate const arrays on the stack, instead make them static.
> Makes the object code smaller by over 740 bytes.

Applied to 4.15/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
