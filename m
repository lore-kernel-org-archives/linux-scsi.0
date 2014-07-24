From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Date: Thu, 24 Jul 2014 08:34:19 -0700
Message-ID: <20140724153419.GA10372@infradead.org>
References: <20140724122223.GA31798@sucs.org>
 <yq1iommkgkv.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <yq1iommkgkv.fsf@sermon.lab.mkp.net>
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
Cc: linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, linux-kernel@vger.kernel.org, jbottomley@parallels.com, ohering@suse.com, Christoph Hellwig <hch@infradead.org>, apw@canonical.com, devel@linuxdriverproject.org, Sitsofe Wheeler <sitsofe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 24, 2014 at 09:54:24AM -0400, Martin K. Petersen wrote:
> I'm very much against short-circuiting the LBP logic in a passthrough
> driver because then we might end up in the exact situation we were
> trying to avoid with this patch series. Namely sending down commands
> unsupported by the target device.
> 
> This kind of thing really needs to be a sysadmin decision and can be
> handled with a udev rule.

I agree - I'd like to pull in KY's simple fix as soon as I get a second
review for it.
