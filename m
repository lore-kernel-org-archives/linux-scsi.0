From: David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH v4] xen-scsiback: define a pr_fmt macro with
 xen-pvscsi
Date: Mon, 16 Mar 2015 14:48:11 +0000
Message-ID: <5506ED2B.7000603@citrix.com>
References: <1426020558-32311-1-git-send-email-boby.chen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426020558-32311-1-git-send-email-boby.chen@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tao Chen <boby.chen@huawei.com>, jgross@suse.com, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, rudy.zhangmin@huawei.com, wu.wubin@huawei.com
List-Id: linux-scsi@vger.kernel.org

On 10/03/15 20:49, Tao Chen wrote:
> Add the {xen-pvscsi: } prefix in pr_fmt and remove DPRINTK, then
> replace all DPRINTK with pr_debug.
> 
> Also fixed up some comments just as eliminate redundant whitespace
> and format the code.
> 
> These will make the code easier to read.

Applied to devel/for-linus-4.1, thanks.

David
