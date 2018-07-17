From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V5 2/2] scsi: ufs: Add configfs support for ufs
 provisioning
Date: Tue, 17 Jul 2018 05:48:05 -0700
Message-ID: <20180717124805.GB22099@infradead.org>
References: <1530858040-13971-1-git-send-email-sayalil@codeaurora.org>
 <1530858040-13971-3-git-send-email-sayalil@codeaurora.org>
 <20180708202136.GA1546@infradead.org>
 <4964583a-d13f-7b92-9838-e4398ec8c682@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4964583a-d13f-7b92-9838-e4398ec8c682@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sayali Lokhande <sayalil@codeaurora.org>
Cc: Christoph Hellwig <hch@infradead.org>, subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, riteshh@codeaurora.org, linux-scsi@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 11, 2018 at 03:20:06PM +0530, Sayali Lokhande wrote:
> Agree. Will add separate config for UFS Provision and set it dependent on
> CONFIGFS_FS

Please add an actual CONFIG_UFS_PROVISIONING user selectable option.
