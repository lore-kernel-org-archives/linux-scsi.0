From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 01/16] lpfc: Correct WQ creation for pagesize
Date: Tue, 7 Mar 2017 20:57:04 +0100
Message-ID: <20170307195704.GB25619@kroah.com>
References: <58a0d919.08BhoypOnvRSLIqV%jsmart2021@gmail.com>
 <6a197069-2f10-6df1-4cf1-1a62808c8903@linux.vnet.ibm.com>
 <yq1tw75kbdn.fsf@oracle.com>
 <7c6d6f3b-330c-ea6f-ad3f-65479354c94d@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7c6d6f3b-330c-ea6f-ad3f-65479354c94d@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org, James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 07, 2017 at 10:44:51AM -0300, Mauricio Faria de Oliveira wrote:
> Hello stable kernel maintainers,
> 
> On 03/07/2017 12:35 AM, Martin K. Petersen wrote:
> > Mauricio> Please flag this patch for stable.
> > 
> > Mauricio> This patch resolves a serious problem on IBM Power systems at
> > Mauricio> least.
> > 
> > Both patches are already upstream so I can't tag them for stable. Either
> > you or James should mail stable@vger.kernel.org and request for the
> > patches to be queued up.
> 
> Can this commit be included on stable v4.4+ , please? (in Linus tree)
> 
>     8ea73db486cda442f0671f4bc9c03a76be398a28 "scsi: lpfc: Correct WQ
> creation for pagesize"

I need an ack from a scsi maintainer that this is an ok thing to do
before I can do so.

thanks,

greg k-h
