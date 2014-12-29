From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 0/4] Drivers: scsi: storvsc: Fix miscellaneous issues
Date: Mon, 29 Dec 2014 21:07:59 +0000
Message-ID: <BY2PR0301MB0711853294B88172F1AAF24FA0510@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418764880-11183-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1418764880-11183-1-git-send-email-kys@microsoft.com>
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
To: KY Srinivasan <kys@microsoft.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Tuesday, December 16, 2014 1:21 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org
> Cc: KY Srinivasan
> Subject: [PATCH 0/4] Drivers: scsi: storvsc: Fix miscellaneous issues
> 
> The first two patches in this series are a resend; these were submitted some
> months ago and as far as I know, there were no outstanding issues.
> 
> Win8 and win8 r2 hosts do support SPC-3 features but claim SPC-2
> compliance.
> This issue is fixed here as well.
> 
> K. Y. Srinivasan (4):
>   Drivers: scsi: storvsc: In responce to a scan event, scan the host
>   Drivers: scsi: storvsc: Force discovery of LUNs that may have been
>     removed.
>   Drivers: scsi: storvsc: Fix a bug in storvsc limits
>   Drivers: scsi: storvsc: Force SPC-3 compliance on win8 and win8 r2
>     hosts

Christoph,

Should I be resending these patches.

Regards,

K. Y
> 
>  drivers/scsi/storvsc_drv.c |   71
> +++++++++++++++++++++++++++++++++++--------
>  1 files changed, 57 insertions(+), 14 deletions(-)
> 
> --
> 1.7.4.1
