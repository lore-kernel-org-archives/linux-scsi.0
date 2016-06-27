From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH v4 7/8] mmc: block: register RPMB partition with the
 RPMB subsystem
Date: Mon, 27 Jun 2016 10:17:25 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B54288DE2@hasmsx108.ger.corp.intel.com>
References: <1464817292-5407-1-git-send-email-tomas.winkler@intel.com>
 <1464817292-5407-8-git-send-email-tomas.winkler@intel.com>
 <576B7F10.2000508@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <576B7F10.2000508@intel.com>
Content-Language: en-US
Sender: linux-mmc-owner@vger.kernel.org
To: "Hunter, Adrian" <adrian.hunter@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Arve Hj?nnev?g <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Usyskin, Alexander" <alexander.usyskin@intel.com>
List-Id: linux-scsi@vger.kernel.org

> 2;
> 
> This looks like it does not support 8KB writes added in v5.1 spec.  Can that be
> supported?

You are right there is not support for 8K packet, but the change should be simple. 
I will update the patch.
Thanks
Tomas 

