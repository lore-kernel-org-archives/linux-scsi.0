From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 09/11] scsi: ufs: connect to RPMB subsystem
Date: Mon, 7 Nov 2016 22:37:54 +0100
Message-ID: <20161107213754.GA10433@lst.de>
References: <1478548394-8184-1-git-send-email-tomas.winkler@intel.com> <1478548394-8184-10-git-send-email-tomas.winkler@intel.com> <20161107190109.GA5110@lst.de> <5B8DA87D05A7694D9FA63FD143655C1B5431750E@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B5431750E@hasmsx108.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, "Hunter, Adrian" <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Arve Hj?nnev?g <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Yaniv Gardi <ygardi@codeaurora.org>, Avri Altman <avri.altman@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 07, 2016 at 07:27:38PM +0000, Winkler, Tomas wrote:
> I  value your opinion but I'm not responsible for inventing RPMB 
> and/or its  implementation storage devices (eMMC, UFC, NVMe), it's pretty much done deal out there in the wild. 
> I'm just trying to provide common API above it.

And the common API must go through the SCSI midlayer.  If it can't we
won't support it, so please drop the UFS patches from the series.
