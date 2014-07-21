From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Date: Mon, 21 Jul 2014 13:19:08 +0000
Message-ID: <a496b63900874bd396e85a24505e383b@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1405913622-14266-1-git-send-email-kys@microsoft.com>
 <20140721112704.GA15455@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140721112704.GA15455@infradead.org>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, July 21, 2014 4:27 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; apw@canonical.com;
> jasowang@redhat.com; jbottomley@parallels.com; hch@infradead.org;
> linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
> 
> On Sun, Jul 20, 2014 at 08:33:42PM -0700, K. Y. Srinivasan wrote:
> > Add blist flags to permit the reading of the VPD pages even when the
> > target may claim SPC-2 compliance. MSFT targets currently claim SPC-2
> > compliance while they implement post SPC-2 features.
> > With this patch we can correctly handle WRITE_SAME_16 issues.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> This looks way to complicated - should be a single line added to your
> slave_configure function, maybe plus a comment stating what you do in your
> commit message:
> 
> 
> 	sdev->sdev_bflags |= BLIST_TRY_VPD_PAGES;

Thanks Christoph. We can go with this. I will re-send the patch.


K. Y
