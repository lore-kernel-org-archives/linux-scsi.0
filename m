From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v7 2/3] scsi: ufs: add debugfs for ufs
Date: Fri, 27 Mar 2015 14:05:06 +0100
Message-ID: <1427461506.2250.19.camel@HansenPartnership.com>
References: <1426175700-23152-1-git-send-email-gbroner@codeaurora.org>
	 <1426175700-23152-3-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426175700-23152-3-git-send-email-gbroner@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Broner <gbroner@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Lee Susman <lsusman@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-03-12 at 17:54 +0200, Gilad Broner wrote:
> From: Lee Susman <lsusman@codeaurora.org>
> 
> Adding debugfs capability for ufshcd.

This patch fails to build as a module because you aren't building
corectly:

ERROR: "ufsdbg_add_debugfs" [drivers/scsi/ufs/ufshcd.ko] undefined!
ERROR: "ufsdbg_remove_debugfs" [drivers/scsi/ufs/ufshcd.ko] undefined!
scripts/Makefile.modpost:90: recipe for target '__modpost' failed

CONFIG_DEBUG_FS is y in my system not m, so your Makefile fails.

James
