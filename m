From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Date: Thu, 24 Jul 2014 17:24:27 +0100
Message-ID: <20140724162427.GA10962@sucs.org>
References: <20140724122223.GA31798@sucs.org>
 <yq1iommkgkv.fsf@sermon.lab.mkp.net>
 <20140724153419.GA10372@infradead.org>
 <20140724153513.GA10752@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20140724153513.GA10752@infradead.org>
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
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 24, 2014 at 08:35:13AM -0700, Christoph Hellwig wrote:
> On Thu, Jul 24, 2014 at 08:34:19AM -0700, Christoph Hellwig wrote:
> > I agree - I'd like to pull in KY's simple fix as soon as I get a second
> > review for it.
> 
> Ok, looks like I just got that from Hannes.  Let's see if there's more
> to be done for the pass through case, but I'd rather wait for the next
> window for that.

There's nothing Linux can do for today's Hyper-V passthrough wrt to
automatically turning on discard on my SATA SSD.

Martin explained that vendors often disable UNMAP/WRITE SAME to DSM TRIM
translation on purpose and/or have explicit device whitelists/blacklists
for those devices they want to support. It could be that Microsoft are
doing something similar (although it might be interesting to know how a
Windows 2012 guest on Hyper-V handles things).

-- 
Sitsofe | http://sucs.org/~sits/
