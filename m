From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH resend] scsi: ufs: ufshcd_dump_regs to use memcpy_fromio
Date: Mon, 18 Jun 2018 22:20:33 -0400
Message-ID: <yq1fu1jikjy.fsf@oracle.com>
References: <20180614081409.29780-1-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180614081409.29780-1-tomas.winkler@intel.com> (Tomas Winkler's
        message of "Thu, 14 Jun 2018 11:14:09 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, Christoph Hellwig <hch@lst.de>, Vivek Gautam <vivek.gautam@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Alex Lemberg <Alex.Lemberg@wdc.com>, Avri Altman <Avri.Altman@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Tomas,

> ufshcd_dump_regs should use memcpy_fromio to read host registers
> instead of directly accessing using memcpy.  The same function is
> utilized in ufs-qcom.

Applied to 4.19/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
