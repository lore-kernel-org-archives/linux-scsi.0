From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] scsi: storvsc: Support manual scan of FC hosts on
 Hyper-V
Date: Tue, 15 Mar 2016 14:27:53 +0000
Message-ID: <SN2PR03MB21423A42522A21C145896431A0890@SN2PR03MB2142.namprd03.prod.outlook.com>
References: <1457819568-6586-1-git-send-email-kys@microsoft.com>
 <20160315134009.GA3595@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20160315134009.GA3595@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Tuesday, March 15, 2016 6:40 AM
> To: KY Srinivasan <kys@microsoft.com>
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> martin.petersen@oracle.com; hare@suse.de
> Subject: Re: [PATCH 1/1] scsi: storvsc: Support manual scan of FC hosts on
> Hyper-V
> 
> On Sat, Mar 12, 2016 at 01:52:48PM -0800, K. Y. Srinivasan wrote:
> > The default user scan function associated with FC (fc_user_scan)
> > is not suitable for FC hosts on Hyper-V since we don't have
> > an rport associated with FC host on Hyper-V . Set it to NULL so we can
> > support manual scan of FC targets on Hyper-V.
> 
> This isn't really how the FC transport class in intended to work, but
> neither is the eh_timed_out (which I haven't seen in my tree yet).
> 
> It sounds like storvsc simply shouldn't attach to the FC transport
> if it doesn't actually look like a FC HBA.

Till recently I had not. However, we do support publishing wwn in the guest and
some customers wanted this. That is the reason I am attaching FC transport and working
through the issues. With this change, I now have wwn names published in the guest and I can
also issue manual scan.


Regards,

K. Y 
