From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Date: Wed, 10 Dec 2014 22:28:07 +0000
Message-ID: <BL2PR03MB1324E11F2CB6EC2652C2F85CE620@BL2PR03MB132.namprd03.prod.outlook.com>
References: <1418200705-488-1-git-send-email-longli@microsoft.com>
 <yq1h9x3cipr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <yq1h9x3cipr.fsf@sermon.lab.mkp.net>
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

> >>>>> "Long" == Long Li <longli@microsoft.com> writes:
> 
> Long> MSFT targets currently claim SPC-2 compliance while they implement
> Long> post SPC-2 features. With this patch we can correctly handle
> Long> WRITE_SAME_16 issues.
> 
> Handle the issues or handle WRITE SAME(10/16)?

With this patch, the SCSI layer will be able to correctly send WRITE_SAME_16 to the Hyper-V host. It will not send WRITE_SAME_10: it has been disabled in the driver template. Do you want me to send another patch with these details?

> 
> +	{"Msft", "Virtual Disk", "1.0", BLIST_TRY_VPD_PAGES},
> 
> Is that version field meaningful or is it safe for us to inquire about VPD pages
> without problems on older versions?

This version is used in all current Hyper-V hosts: Windows 2008 R2, 2012 and 2012 R2. However it may change in future Windows releases.

> 
> --
> Martin K. Petersen	Oracle Linux Engineering
