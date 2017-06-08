From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH V4 2/2] scsi: ufshcd-pci: Add Intel CNL support
Date: Thu, 8 Jun 2017 10:36:12 +0100
Message-ID: <21c668c5-251a-bc19-f0ba-3826d3515145@synopsys.com>
References: <1496748931-17162-1-git-send-email-adrian.hunter@intel.com>
 <1496748931-17162-3-git-send-email-adrian.hunter@intel.com>
 <20170607131625.GB18252@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170607131625.GB18252@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Adrian Hunter <adrian.hunter@intel.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Subhash Jadavani <subhashj@codeaurora.org>, Santosh Yaragnavi <santosh.sy@samsung.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Szymon Mielczarek <szymonx.mielczarek@intel.com>, Michal Potomski <michalx.potomski@intel.com>, Grzegorz Janca <grzegorz.janca@intel.com>, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

Hello to all,

Às 2:16 PM de 6/7/2017, Christoph Hellwig escreveu:
> On Tue, Jun 06, 2017 at 02:35:31PM +0300, Adrian Hunter wrote:
>> Add PCI id and variant ops for Intel CNL UFS host controller.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> It would be great if we could fold tc-dwc-g210-pci into ufshcd-pci the
> same way.
> 

I have forward the suggestion to the person on charge of UFS driver maintenance
at Synopsys. We will definitely have a look at it!

Thanks,
Joao
