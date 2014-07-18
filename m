From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Date: Fri, 18 Jul 2014 17:03:47 +0000
Message-ID: <1405703026.30262.4.camel@dabdike.int.hansenpartnership.com>
References: <1401899623-24194-1-git-send-email-kys@microsoft.com>
 <20140718170030.GA31769@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140718170030.GA31769@infradead.org>
Content-Language: en-US
Content-ID: <2943970F8F8607439B3B7338ECD5C698@sw.swsoft.com>
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
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-07-18 at 10:00 -0700, Christoph Hellwig wrote:
> On Wed, Jun 04, 2014 at 09:33:43AM -0700, K. Y. Srinivasan wrote:
> > Commit ID: 7e660100d85af860e7ad763202fff717adcdaacd added code to derive the
> > FLUSH_TIMEOUT from the basic I/O timeout. However, this patch did not use the
> > basic I/O timeout of the device. Fix this bug.
> > 
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> Looks good to me,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> (it will need some changes to apply to my tree, but I'm happy to do that
> if I can get another review).
> 
> James, does this look fine to you?

Yes:

Reviewed-by: James Bottomley <JBottomley@Parallels.com>

James
