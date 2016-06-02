From: =?UTF-8?B?SsOpcsO0bWUgRm9yaXNzaWVy?= <jerome.forissier@linaro.org>
Subject: Re: [v4,4/8] char: rpmb: provide user space interface
Date: Thu, 2 Jun 2016 15:44:57 +0200
Message-ID: <57503859.6090605@linaro.org>
References: <1464817292-5407-5-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464817292-5407-5-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, =?UTF-8?Q?Arve_Hj=c3=b8nnev=c3=a5g?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Tomas,

On 06/01/2016 11:41 PM, Winkler, Tomas wrote:
> The user space API is achieved via single synchronous IOCTL.
> The request is submitted in in_frames_ptr pointer and received
> in out_frames_ptr.

I like this, because it's exactly what I wish existed when I wrote the
eMMC RPMB back-end for OP-TEE secure storage [1] ;-)

Same goes for patch 5/8 "char: rpmb: add RPMB simulation device": with
this I could just drop my custom simulation layer.

So, this goes in the right direction IMHO.

[1]
https://github.com/OP-TEE/optee_client/blob/master/tee-supplicant/src/rpmb.c

-- 
Jerome
