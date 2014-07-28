From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Date: Mon, 28 Jul 2014 19:05:10 +0000
Message-ID: <548c8b1bae75483aa47c9493b62dc04d@BY2PR0301MB0711.namprd03.prod.outlook.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <yq11tt5cnmx.fsf@sermon.lab.mkp.net>
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
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, Sitsofe Wheeler <sitsofe@gmail.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Monday, July 28, 2014 12:03 PM
> To: KY Srinivasan
> Cc: Martin K. Petersen; Sitsofe Wheeler; Christoph Hellwig;
> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; apw@canonical.com;
> jasowang@redhat.com; jbottomley@parallels.com; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
> 
> >>>>> "KY" == KY Srinivasan <kys@microsoft.com> writes:
> 
> KY,
> 
> KY> "At the time thin-provisioning was defined, the discovery
> KY> information was first proposed in READ CAPACITY 16 command. And
> then
> KY> moved into the new dedicated VPD page - B2h. You can see the
> KY> information reported in this VPD page is richer than READ CAPACITY
> KY> 16 command. As this transition happened during we added the feature,
> KY> Windows uses the newer method that based on VPD page B2h. It looks
> KY> Linux tries to use both new and old method which is weird to me."
> 
> The READ CAPACITY(16) response is not optional.

Ok; that settles the issue then. I will attempt to get it fixed on Windows.

K. Y

> 
> --
> Martin K. Petersen	Oracle Linux Engineering
