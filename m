From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Date: Thu, 11 Dec 2014 10:53:45 +0000
Message-ID: <20141211101945.GA25624@sucs.org>
References: <1418200705-488-1-git-send-email-longli@microsoft.com>
 <yq1h9x3cipr.fsf@sermon.lab.mkp.net>
 <BL2PR03MB1324E11F2CB6EC2652C2F85CE620@BL2PR03MB132.namprd03.prod.outlook.com>
 <BY2PR0301MB0711CF1C9FBD8EFED89B3911A0620@BY2PR0301MB0711.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <BY2PR0301MB0711CF1C9FBD8EFED89B3911A0620@BY2PR0301MB0711.namprd03.prod.outlook.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, Haiyang Zhang <haiyangz@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 10, 2014 at 11:30:30PM +0000, KY Srinivasan wrote:
> 
> > >
> > > +	{"Msft", "Virtual Disk", "1.0", BLIST_TRY_VPD_PAGES},
> > >
> > > Is that version field meaningful or is it safe for us to inquire about
> > > VPD pages without problems on older versions?
> > 
> > This version is used in all current Hyper-V hosts: Windows 2008 R2, 2012 and
> > 2012 R2. However it may change in future Windows releases.
> 
> The next version of the host will be claiming conformance to SPC-3

Will the version number ("1.0") of Virtual Disks also be changed? Part
of me hopes it will as it will mean certain quirks for virtual disks
will be easier to apply and won't need host version (are you 2008, 2012,
2016) version logic...

-- 
Sitsofe | http://sucs.org/~sits/
