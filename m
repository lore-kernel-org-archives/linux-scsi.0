From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Date: Mon, 28 Jul 2014 20:05:24 +0000
Message-ID: <cca020b4c9a74752bf7025085ce528cd@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20140724122223.GA31798@sucs.org>
 <yq1iommkgkv.fsf@sermon.lab.mkp.net> <20140724153612.GA23648@sucs.org>
 <yq1egxakb0z.fsf@sermon.lab.mkp.net>
 <16fea5bb87ba47019527cee788e07a72@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <yq1wqb1gyw1.fsf@sermon.lab.mkp.net>
 <e931486ef33b4e45bfebf2ab1b1b3037@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <yq17g30dprc.fsf@sermon.lab.mkp.net>
 <cc4a3fd5451242739929d266b88fa8fa@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <yq138dnexcn.fsf@sermon.lab.mkp.net>
 <43306901b1dc4e5dbe014a431e0935ea@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <yq11tt5cnmx.fsf@sermon.lab.mkp.net>
 <548c8b1bae75483aa47c9493b62dc04d@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <1406577767.19418.11.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1406577767.19418.11.camel@jarvis>
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
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "sitsofe@gmail.com" <sitsofe@gmail.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Monday, July 28, 2014 1:03 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; hch@infradead.org; sitsofe@gmail.com;
> devel@linuxdriverproject.org; apw@canonical.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org;
> ohering@suse.com; gregkh@linuxfoundation.org; jasowang@redhat.com
> Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
> 
> On Mon, 2014-07-28 at 19:05 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> > > Sent: Monday, July 28, 2014 12:03 PM
> > > To: KY Srinivasan
> > > Cc: Martin K. Petersen; Sitsofe Wheeler; Christoph Hellwig;
> > > gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; ohering@suse.com; apw@canonical.com;
> > > jasowang@redhat.com; jbottomley@parallels.com; linux-
> > > scsi@vger.kernel.org
> > > Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks
> > > tests
> > >
> > > >>>>> "KY" == KY Srinivasan <kys@microsoft.com> writes:
> > >
> > > KY,
> > >
> > > KY> "At the time thin-provisioning was defined, the discovery
> > > KY> information was first proposed in READ CAPACITY 16 command. And
> > > then
> > > KY> moved into the new dedicated VPD page - B2h. You can see the
> > > KY> information reported in this VPD page is richer than READ
> > > KY> CAPACITY
> > > KY> 16 command. As this transition happened during we added the
> > > KY> feature, Windows uses the newer method that based on VPD page
> > > KY> B2h. It looks Linux tries to use both new and old method which is
> weird to me."
> > >
> > > The READ CAPACITY(16) response is not optional.
> >
> > Ok; that settles the issue then. I will attempt to get it fixed on Windows.
> 
> Like Martin says, this isn't optional either/or; it's mandatory to support the RC
> 16 bits.  If you don't want to get into playing the messenger between us and
> the windows guys on SCSI standards, we'd be happy to communicate
> directly, either by email or a phone meeting.

Thanks James. I will take up your offer if needed.

Regards,

K. Y
