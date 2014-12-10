From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Date: Wed, 10 Dec 2014 22:33:26 +0000
Message-ID: <BL2PR03MB132331596398113A8F15B45CE620@BL2PR03MB132.namprd03.prod.outlook.com>
References: <1418200705-488-1-git-send-email-longli@microsoft.com>
 <20141210205746.GB1209@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20141210205746.GB1209@sucs.org>
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
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Wednesday, December 10, 2014 12:58 PM
> To: Long Li
> Cc: KY Srinivasan; Haiyang Zhang; JBottomley@parallels.com; linux-
> scsi@vger.kernel.org; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
> 
> On Wed, Dec 10, 2014 at 12:38:25AM -0800, Long Li wrote:
> > MSFT targets currently claim SPC-2 compliance while they implement
> > post SPC-2 features. With this patch we can correctly handle
> > WRITE_SAME_16 issues.
> >
> > This patch fixes an issue where the flag is setup too late in drive
> > initialization process.
> 
> Li, is this a fix for the issue I keep whinging about over in
> https://lkml.org/lkml/2014/10/21/23 ?
> 
> If is the same issue you may want to CC Martin on this...

This is only for fixing WRITE_SAME_16. The rest of the thin provisioning (e.g. UNMAP) is still broken on SPC-2.

> 
> --
> Sitsofe | http://sucs.org/~sits/
