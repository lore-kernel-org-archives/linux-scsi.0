From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 RESEND 17/23] pm8001: Fix invalid return when
 request_irq() failed
Date: Tue, 29 Jul 2014 06:20:20 -0700
Message-ID: <20140729132020.GA7714@infradead.org>
References: <cover.1405533479.git.agordeev@redhat.com>
 <5ecd9b80f705545c3dc85b2a4ae63a8ac3df8105.1405533479.git.agordeev@redhat.com>
 <53D79DE2.9000702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53D79DE2.9000702@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org, xjtuwjp@gmail.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 29, 2014 at 03:13:06PM +0200, Tomas Henzl wrote:
> Hi, 
> patch looks good.
> 
> A correction in pm8001_request_irq might be added too to allow 
> the INT-X path when pm8001_setup_msix fails, but that is not part 
> of this fix.


There's actually an equivalent fix already in through one of the
previous pm8001 updates, so I skipped this one even if it already had an
ACK.  The following pm8001 applied just fine, though.  Take a look, as
I've already pushed out the updated drivers branch.
