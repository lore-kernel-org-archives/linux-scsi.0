From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH 0/3] scsi: arcmsr: add driver module parameter -
 msi_enable, msix_enable
Date: Fri, 24 Nov 2017 03:12:39 +0800
Message-ID: <1511464359.4370.3.camel@Centos6.3-64>
References: <1511400123.9832.14.camel@Centos6.3-64>
         <20171123125739.GA25627@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171123125739.GA25627@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, dan.carpenter@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-11-23 at 04:57 -0800, Christoph Hellwig wrote:
> On Thu, Nov 23, 2017 at 09:22:03AM +0800, Ching Huang wrote:
> > From: Ching Huang <ching2048@areca.com.tw>
> > 
> > Hi all,
> > 
> > The following patches apply to Martin's 4.16/scsi-queue.
> > 
> > Patch 1: Add module parameter msi_enable to has a chance to disable msi interrupt if it does not work properly.
> > 
> > Patch 2: Add module parameter msix_enable to has a chance to disable msix interrupt if it does not work properly.
> 
> Why would it not work properly?
This patch is apply to
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/tree/?h=4.16/scsi-queue
