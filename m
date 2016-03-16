From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: storvsc: Support manual scan of FC hosts on
 Hyper-V
Date: Wed, 16 Mar 2016 18:34:45 -0400
Message-ID: <yq14mc6dpbu.fsf@sermon.lab.mkp.net>
References: <1457819568-6586-1-git-send-email-kys@microsoft.com>
 <20160315134009.GA3595@infradead.org>
 <SN2PR03MB21423A42522A21C145896431A0890@SN2PR03MB2142.namprd03.prod.outlook.com>
 <yq1twk7e8nl.fsf@sermon.lab.mkp.net>
 <SN2PR03MB21425F84DAC997491DD4C2ACA0890@SN2PR03MB2142.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <SN2PR03MB21425F84DAC997491DD4C2ACA0890@SN2PR03MB2142.namprd03.prod.outlook.com>
 (KY Srinivasan's message of "Tue, 15 Mar 2016 23:01:03 +0000")
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
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "KY" == KY Srinivasan <kys@microsoft.com> writes:

KY> How would I get the sysfs files under fc_host if I don't use the FC
KY> transport.  The customer scripts expect these sysfs files.

Right, but I was interested in finding out why they need those
files. And whether an alternative to the FC transport would be a better
solution.

-- 
Martin K. Petersen	Oracle Linux Engineering
