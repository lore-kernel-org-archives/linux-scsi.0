From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Check that space was properly alloced in copy_query_response
Date: Tue, 04 Jun 2019 22:11:54 -0400
Message-ID: <yq14l54srv9.fsf@oracle.com>
References: <1558427062-5084-1-git-send-email-avri.altman@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1558427062-5084-1-git-send-email-avri.altman@wdc.com> (Avri
        Altman's message of "Tue, 21 May 2019 11:24:22 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <avri.altman@wdc.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Evan Green <evgreen@chromium.org>, Bean Huo <beanhuo@micron.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Alim Akhtar <alim.akhtar@samsung.com>, Avi Shchislowski <avi.shchislowski@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>
List-Id: linux-scsi@vger.kernel.org


Avri,

> struct ufs_dev_cmd is the main container that supports device management
> commands. In the case of a read descriptor request, we assume that the
> proper space was allocated in dev_cmd to hold the returning descriptor.
>
> This is no longer true, as there are flows that doesn't use dev_cmd
> for device management requests, and was wrong in the first place.

Applied to 5.2/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
