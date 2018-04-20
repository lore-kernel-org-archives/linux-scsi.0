From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][V2] isci: Fix infinite loop in while loop
Date: Fri, 20 Apr 2018 19:24:47 -0400
Message-ID: <yq1a7txh35s.fsf@oracle.com>
References: <20180420095716.2143-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180420095716.2143-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 20 Apr 2018 10:57:16 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> In the case when the phy_mask is bitwise anded with the phy_index bit
> is zero the continue statement currently jumps to the next iteration
> of the while loop and phy_index is never actually incremented,
> potentially causing an infinite loop if phy_index is less than
> SCI_MAX_PHS. Fix this by turning the while loop into a for loop.

Applied to 4.17/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
