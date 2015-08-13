From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: fix init_vp_index() for
 reloading hv_netvsc
Date: Fri, 14 Aug 2015 02:19:30 +0300
Message-ID: <20150813231930.GA4496@mwanda>
References: <1439510823-16280-1-git-send-email-kys@microsoft.com>
 <1439507350.8421.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1439507350.8421.13.camel@HansenPartnership.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 13, 2015 at 04:09:10PM -0700, James Bottomley wrote:
> On Thu, 2015-08-13 at 17:07 -0700, K. Y. Srinivasan wrote:
> > From: Dexuan Cui <decui@microsoft.com>
> > 
> > This fixes the recent commit 3b71107d73b16074afa7658f3f0fcf837aabfe24:
> 
> Which tree is this in?  upstream linus is giving me bad object on that
> id.
> 

It's in Greg's char-misc-next tree.  I like to have the commit id so I
can look at buggy patches.

regards,
dan carpenter
