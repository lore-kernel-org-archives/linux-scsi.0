From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Date: Tue, 16 Dec 2014 02:11:17 +0000
Message-ID: <BL2PR03MB1327AFA28FF65067FE4672DCE6C0@BL2PR03MB132.namprd03.prod.outlook.com>
References: <1418200705-488-1-git-send-email-longli@microsoft.com>
 <yq1h9x3cipr.fsf@sermon.lab.mkp.net>
 <BL2PR03MB1324E11F2CB6EC2652C2F85CE620@BL2PR03MB132.namprd03.prod.outlook.com>
 <yq1vblhbmcv.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <yq1vblhbmcv.fsf@sermon.lab.mkp.net>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

Thanks Martin for the explanation.

I'll send out another patch.

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Thursday, December 11, 2014 7:04 PM
> To: Long Li
> Cc: Martin K. Petersen; KY Srinivasan; Haiyang Zhang;
> JBottomley@parallels.com; linux-scsi@vger.kernel.org;
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
> 
> >>>>> "Long" == Long Li <longli@microsoft.com> writes:
> 
> >> Handle the issues or handle WRITE SAME(10/16)?
> 
> Long> With this patch, the SCSI layer will be able to correctly send
> Long> WRITE_SAME_16 to the Hyper-V host. It will not send WRITE_SAME_10:
> Long> it has been disabled in the driver template. Do you want me to
> Long> send another patch with these details?
> 
> no_write_same prevents us from attempting to use WRITE SAME(10/16) to zero
> block ranges.
> 
> This is completely orthogonal to using the WRITE SAME(10/16) commands with
> the UNMAP bit set to discard block ranges. The latter is controlled by the logical
> block provisioning heuristics and is not affected by no_write_same at all.
> 
> --
> Martin K. Petersen	Oracle Linux Engineering
