From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Date: Wed, 23 Jul 2014 15:40:37 +0000
Message-ID: <1ed4589a09b74935afd7046fb1a85d2c@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
 <20140723100448.GA2540@sucs.org> <20140723115128.GB16881@infradead.org>
 <20140723125443.GA16103@sucs.org> <20140723141014.GA892@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140723141014.GA892@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Hannes Reinecke
 (hare@suse.de)" <hare@suse.de>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, July 23, 2014 7:10 AM
> To: Sitsofe Wheeler
> Cc: KY Srinivasan; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; ohering@suse.com;
> apw@canonical.com; jasowang@redhat.com; jbottomley@parallels.com;
> linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
> 
> On Wed, Jul 23, 2014 at 01:54:43PM +0100, Sitsofe Wheeler wrote:
> > That's good to know (I was worried the device would not be detected as
> > supporting discard because it doesn't report lbpme and doesn't declare
> > a conformance version (see below)).
> 
> Ok, that makes things worse - you might be able to force it through sysfs,
> though.
> 
> > Is there a tree with all these updates in or do they need to be pieced
> > together from this email thread?
> 
> I'm picking this up for my scsi-queue tree.  Still need a review for the patch
> we're replying to before that one can go in, though.

Hannes, could you please review this patch. Christoph, other than the review of this patch,
Is there something you want done before these can be committed.

Regards,

K. Y
> 
> > Additionally is it worth quirking sd_try_rc16_first on when
> > BLIST_TRY_VPD_PAGES is present?
> 
> Sounds reasonable to me.
