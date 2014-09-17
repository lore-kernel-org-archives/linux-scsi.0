From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
Date: Wed, 17 Sep 2014 16:23:09 -0700
Message-ID: <20140917232309.GA4554@infradead.org>
References: <1409701396-20226-1-git-send-email-kys@microsoft.com>
 <20140905054014.GA11595@infradead.org>
 <155acb7b8a3d4532aaa280e44f62447f@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20140917073324.GB23716@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20140917073324.GB23716@suse.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Olaf Hering <ohering@suse.com>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 17, 2014 at 09:33:24AM +0200, Olaf Hering wrote:
> Christoph,
> 
> what does "review of this" mean?  There are many hv related patches
> floating around.  The removal of the warning in msgid
> <1409701396-20226-1-git-send-email-kys@microsoft.com> looks ok to me.


Thanks, can you give me a Reviewed-by: tag for it?

Also the two patches at
http://thread.gmane.org/gmane.linux.drivers.driver-project.devel/56242/

still need a review, and I'd love to get one to include it for the
3.18 merge window.
