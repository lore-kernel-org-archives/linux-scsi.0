From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Date: Thu, 17 Jul 2014 08:41:09 -0400
Message-ID: <yq1zjg8p38a.fsf@sermon.lab.mkp.net>
References: <20140711063216.GA20660@infradead.org>
 <328b7a6174ef4dd8a54a7db5ac959834@BY2PR03MB299.namprd03.prod.outlook.com>
 <yq1a98d2z5x.fsf@sermon.lab.mkp.net>
 <20140716110111.GA7382@infradead.org>
 <yq14myhtijx.fsf@sermon.lab.mkp.net>
 <20140716173827.GB20528@infradead.org>
 <yq1fvi1rya0.fsf@sermon.lab.mkp.net>
 <1405533734.3165.12.camel@dabdike.int.hansenpartnership.com>
 <94D0CD8314A33A4D9D801C0FE68B402958BA721F@G9W0745.americas.hpqcorp.net>
 <yq138e1rtzz.fsf@sermon.lab.mkp.net>
 <20140717074234.GA7604@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140717074234.GA7604@infradead.org> (hch@infradead.org's
 message of "Thu, 17 Jul 2014 00:42:34 -0700")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, "ohering@suse.com" <ohering@suse.com>, "apw@canonical.com" <apw@canonical.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "Elliott,
 Robert (Server Storage)" <Elliott@hp.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == hch@infradead org <hch@infradead.org> writes:

Christoph> That's mostly because we don't support larger than 512 byte
Christoph> TRIM payloads yet..

I did add support for that a few years back but all hell broke loose and
we had to revert it. There were several drives that failed with more
than 512 bytes of payload despite advertising support for 4K.

It's the same problem that we have now with queued TRIM. There are
several vendors that have implemented it but until we added support in
Linux they had no way of testing it. And as a result their
implementations are buggy. Even with a Linux implementation readily
available it's hard to get them to test since Linux is not a tier 1
platform in the consumer segment. For enterprise drives it's an entirely
different matter, of course...

-- 
Martin K. Petersen	Oracle Linux Engineering
