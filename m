From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3 2/3] scsi: ufs: Add ufs provisioning support
Date: Thu, 14 Jun 2018 08:39:14 -0700
Message-ID: <20180614153914.GA3906@infradead.org>
References: <1528981432-23065-1-git-send-email-sayalil@codeaurora.org>
 <1528981432-23065-3-git-send-email-sayalil@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1528981432-23065-3-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sayali Lokhande <sayalil@codeaurora.org>
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, riteshh@codeaurora.org, linux-scsi@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 14, 2018 at 06:33:51PM +0530, Sayali Lokhande wrote:
> A new api ufshcd_do_config_device() is added in driver
> to support UFS provisioning at runtime. Configfs support
> is added to trigger provisioning.
> Device and Unit configurable parameters are parsed from
> vendor specific provisioning data or file and
> passed via configfs node at runtime to provision ufs device.
> 
> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>

Please make that code conditionally compiled based on a config option.
For most UFS users there is no need to ever enable it.
