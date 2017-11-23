From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] scsi: arcmsr: add driver module parameter -
 msi_enable, msix_enable
Date: Thu, 23 Nov 2017 04:57:39 -0800
Message-ID: <20171123125739.GA25627@infradead.org>
References: <1511400123.9832.14.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1511400123.9832.14.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, dan.carpenter@oracle.com, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 23, 2017 at 09:22:03AM +0800, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
> 
> Hi all,
> 
> The following patches apply to Martin's 4.16/scsi-queue.
> 
> Patch 1: Add module parameter msi_enable to has a chance to disable msi interrupt if it does not work properly.
> 
> Patch 2: Add module parameter msix_enable to has a chance to disable msix interrupt if it does not work properly.

Why would it not work properly?
