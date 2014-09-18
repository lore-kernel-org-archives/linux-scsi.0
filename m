From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
Date: Thu, 18 Sep 2014 16:44:24 +0000
Message-ID: <8eca1b3e8e4a4945a15a770b5700251b@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1409701396-20226-1-git-send-email-kys@microsoft.com>
 <20140905054014.GA11595@infradead.org>
 <155acb7b8a3d4532aaa280e44f62447f@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20140917073324.GB23716@suse.com> <20140917232309.GA4554@infradead.org>
 <20140918115017.GA20884@suse.com> <20140918164324.GA12287@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140918164324.GA12287@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Olaf Hering <ohering@suse.com>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, September 18, 2014 9:43 AM
> To: Olaf Hering
> Cc: KY Srinivasan; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; jbottomley@parallels.com; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
> 
> On Thu, Sep 18, 2014 at 01:50:17PM +0200, Olaf Hering wrote:
> > On Wed, Sep 17, Christoph Hellwig wrote:
> >
> > > Also the two patches at
> > > http://thread.gmane.org/gmane.linux.drivers.driver-project.devel/562
> > > 42/
> >
> > Wasnt the outcome that this was a bad idea? Or at least doing it
> > globally is bad. In any case, its not something I can help with.
> 
> The outcome was that we don't want to do it globally, but it does make sense
> for the hyperv case.

Yes; it has already solved a few open issues. Please apply.

K. Y
