From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH V2 resend] libata:fix kernel panic when hotplug
Date: Tue, 21 Jun 2016 11:47:00 -0400
Message-ID: <20160621154700.GH3262@mtj.duckdns.org>
References: <1466052340-25520-1-git-send-email-dingxiang@huawei.com>
 <20160616202045.GF3262@mtj.duckdns.org>
 <yq160t35oas.fsf@sermon.lab.mkp.net>
 <CAPcyv4hnzAoiPQNHD_6C74exQrDQGaGG-fRw8XAAkj80bv5nqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4hnzAoiPQNHD_6C74exQrDQGaGG-fRw8XAAkj80bv5nqg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, DingXiang <dingxiang@huawei.com>, jejb@linux.vnet.ibm.com, Wei Fang <fangwei1@huawei.com>, miaoxie@huawei.com, wangyijing@huawei.com, zhangaihua1@huawei.com, zhaohongjiang@huawei.com, houtao1@huawei.com, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Mon, Jun 20, 2016 at 06:46:55PM -0700, Dan Williams wrote:
> On Mon, Jun 20, 2016 at 6:22 PM, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
> >>>>>> "Tejun" == Tejun Heo <tj@kernel.org> writes:
> >
> >>> In fact,we don't need libata to deal with hotplug in sas environment.
> >>> So we can't run ata hotplug task when ata port is sas host.
> >
> > Tejun> Martin, can you please confirm whether the above is true.  If so,
> > Tejun> I'll route the patch through libata w/ stable cc'd.
> >
> > Not exactly a libsas expert. James? Dan?
> 
> While it is true that libsas itself handles adding / removing devices
> we have historically avoided this conflict because
> ATA_PFLAG_SCSI_HOTPLUG is never set for libsas ata_ports.  So the bug
> / behavior change is that  ATA_PFLAG_SCSI_HOTPLUG gets set in the
> first place.  Ignoring it is a band-aid / not the real fix afaics.

I see.  I'll hold off for now then.  Ding Xiang, can you find out
where that flag is getting set?

Thanks!

-- 
tejun
