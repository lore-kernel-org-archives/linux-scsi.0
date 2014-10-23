From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] scsi: add try_rc16 blacklist flag
Date: Wed, 22 Oct 2014 21:46:32 -0400
Message-ID: <yq1egtzwoav.fsf@sermon.lab.mkp.net>
References: <20141010074901.GA32028@sucs.org>
 <20141010075251.GC32028@sucs.org> <yq1mw8y6sxf.fsf@sermon.lab.mkp.net>
 <20141021042108.GB11691@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20141021042108.GB11691@sucs.org> (Sitsofe Wheeler's message of
 "Tue, 21 Oct 2014 05:21:08 +0100")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, devel@linuxdriverproject.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:

>> Last time around we identified this as a problem with Microsoft's
>> interpretation of the T10 SBC spec. And they promised that they are
>> going to fix that.

Sitsofe> OK but if we were happy to wait for Microsoft to fix the
Sitsofe> problem on the host why were the (broken and incomplete)
Sitsofe> BLIST_SKIP_VPD_PAGES patches committed to 3.17 rather than
Sitsofe> withdrawn? What's going to be done about those patches now?

There are two orthogonal problems. One being that the driver advertised
conformance to an old SCSI spec. That's being addressed with the
separate SPC-3 patch.

The other issue is that thin provisioning is being incorrectly
advertised. Because that's being addressed by Microsoft and is an
isolated use case I'm hesitant to add quirk for it. Whereas I know
several other devices that will benefit from the TRY_VPD_PAGES blacklist
option.

-- 
Martin K. Petersen	Oracle Linux Engineering
