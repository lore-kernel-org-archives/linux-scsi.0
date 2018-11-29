From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: add fall through annotation
Date: Wed, 28 Nov 2018 21:35:06 -0500
Message-ID: <yq15zwg1uhx.fsf@oracle.com>
References: <20181126081034.30185-1-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181126081034.30185-1-tomas.winkler@intel.com> (Tomas Winkler's
        message of "Mon, 26 Nov 2018 10:10:34 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Avri Altman <Avri.Altman@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Tomas,

> Add /* fallthrough */ annotation, to eliminate compilation warning:
> warning: this statement may fall through [-Wimplicit-fallthrough=]

Applied to 4.20/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
