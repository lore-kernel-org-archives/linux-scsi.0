From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH v7 09/11] scsi: ufs: connect to RPMB subsystem
Date: Mon, 7 Nov 2016 19:27:38 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B5431750E@hasmsx108.ger.corp.intel.com>
References: <1478548394-8184-1-git-send-email-tomas.winkler@intel.com>
 <1478548394-8184-10-git-send-email-tomas.winkler@intel.com>
 <20161107190109.GA5110@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <20161107190109.GA5110@lst.de>
Content-Language: en-US
Sender: linux-mmc-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, "Hunter, Adrian" <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Arve Hj?nnev?g <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Yaniv Gardi <ygardi@codeaurora.org>, Avri Altman <avri.altman@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "Usyskin, Alexander" <alexan>
List-Id: linux-scsi@vger.kernel.org

> 
> On Mon, Nov 07, 2016 at 09:53:12PM +0200, Tomas Winkler wrote:
> > Register UFS RPMB LUN with the RPMB subsystem and provide
> > implementation for the RPMB access operations. RPMB partition is
> > accessed via a sequence of security protocol in and security protocol
> > out commands with UFS specific parameters. This multi step process is
> > abstracted into 4 basic RPMB commands.
> 
> This is a giant layering violation - the security protocol is not something up to
> the LLDD but the core code.
> 
> And honestly the idea of defintining a security protocol in the UFS spec is just
> as braindead.  If you care about this please take it up with T10 to get RPMB
> support into one of the core SCSI specs instead of a transport.

I  value your opinion but I'm not responsible for inventing RPMB 
and/or its  implementation storage devices (eMMC, UFC, NVMe), it's pretty much done deal out there in the wild. 
I'm just trying to provide common API above it.

Thanks
Tomas

