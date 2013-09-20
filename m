From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Drivers: scsi: FLUSH timeout
Date: Fri, 20 Sep 2013 13:32:22 -0700
Message-ID: <20130920203222.GA14306@kroah.com>
References: <1379705547-15028-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1379705547-15028-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jbottomley@parallels.com, ohering@suse.com, hch@infradead.org, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 20, 2013 at 12:32:27PM -0700, K. Y. Srinivasan wrote:
> The SD_FLUSH_TIMEOUT value is currently hardcoded.

Hardcoded where?  Please, more context.

> On our cloud, we sometimes hit this timeout. I was wondering if we
> could make this a module parameter. If this is acceptable, I can send
> you a patch for this.

A module parameter don't make sense for a per-device value, does it?

greg k-h
