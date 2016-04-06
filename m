From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH v2 8/8] scsi: ufs: connect to RPMB subsystem
Date: Wed, 6 Apr 2016 09:51:23 +0100
Message-ID: <5704CE0B.2010700@synopsys.com>
References: <1459768284-26997-1-git-send-email-tomas.winkler@intel.com>
 <1459768284-26997-9-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <1459768284-26997-9-git-send-email-tomas.winkler@intel.com>
Sender: linux-mmc-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>, gregkh@linuxfoundation.org, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Joao Pinto <Joao.Pinto@synopsys.com>, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Usyskin <alexander.usyskin@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hi!

On 4/4/2016 12:11 PM, Tomas Winkler wrote:
> Register UFS RPMB LUN with the RPMB subsystem and provide
> implementation for the RPMB access operations. RPMB partition is
> accessed via a sequence of security protocol in and security protocol
> out commands with UFS specific parameters. This multi step process is
> abstracted into 4 basic RPMB commands.

[snip]

>  	 * "UFS device" W-LU.
>  	 */
>  	struct scsi_device *sdev_ufs_device;
> +	struct scsi_device *sdev_ufs_rpmb;
>  
>  	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
>  	enum uic_link_state uic_link_state;
> 

I have a UFS device emulator that has the RPMB capability. What are the expected
good results for me to validate?

Thanks.
