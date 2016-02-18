From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/7] ahci: Convert driver to use modern PM hooks
Date: Thu, 18 Feb 2016 08:12:46 -0500
Message-ID: <20160218131246.GF6479@mtj.duckdns.org>
References: <1455785657-22924-1-git-send-email-mika.westerberg@linux.intel.com>
 <1455785657-22924-6-git-send-email-mika.westerberg@linux.intel.com>
 <CAHp75Vc0F=-5Whiw_CO+_YeL=HsN=GiGprKRd2q9vx_kqT02HA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHp75Vc0F=-5Whiw_CO+_YeL=HsN=GiGprKRd2q9vx_kqT02HA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 18, 2016 at 12:45:05PM +0200, Andy Shevchenko wrote:
> > +       .driver.pm              = &ahci_pci_pm_ops,
> 
> Please, do this in several assignments, since to support older compilers.

Can you please elaborate?  That's a single assignment.  Are there
compilers which can't do that?

Thanks.

-- 
tejun
