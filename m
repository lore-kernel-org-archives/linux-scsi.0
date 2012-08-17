From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE] target-pending tree updated to v3.6-rc2
Date: Thu, 16 Aug 2012 23:49:44 -0700
Message-ID: <1345186184.25161.141.camel@haakon2.linux-iscsi.org>
References: <1345171412.25161.134.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1345171412.25161.134.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Alex Elsayed <eternaleye+usenet@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-08-16 at 19:43 -0700, Nicholas A. Bellinger wrote:
> Hi all,
> 
> With the release of v3.6-rc2 this afternoon, the target-pending.git tree
> now has been updated using the freshly cut -rc2 as it's new HEAD.
> Patches destined into for-3.7 code are now being added into for-next for
> linux-next build testing.
> 
> Also, thanks go out to MST, Stefan, and Paolo who managed to get
> tcm_vhost fabric code merged in mainline for -rc2  under the special
> post merge window exception rule for new kernel code, which in my
> experience tends to happens about as often as Haley's comet comes
> around..
> 
> Here is the current breakdown of pending patches by branch:
> 
> master: (patches headed for 3.6-rc-fixes)
> 
> 5b7517f8 tcm_vhost: Change vhost_scsi_target->vhost_wwpn to char *
> d0e27c88 target: fix NULL pointer dereference bug alloc_page() fails to get memory
> 1fa8f450 tcm_fc: Avoid debug overhead when not debugging
> 101998f6 tcm_vhost: Post-merge review changes requested by MST
> f0e0e9bb tcm_vhost: Fix incorrect IS_ERR() usage in vhost_scsi_map_iov_to_sgl
> 

Whoops..  Missed one extra target/pscsi regression bug-fix reported
recently by Alex Elsayed (CC'ed) that has just been pushed into master
here:

target/pscsi: Fix bug with REPORT_LUNs handling for SCSI passthrough
http://git.kernel.org/?p=linux/kernel/git/nab/target-pending.git;a=commitdiff;h=1d2a2cd95ee0137a2353d1b5635739c281f27cd4

Alex-E, you where able to get TYPE_ROM passthrough w/ pSCSI export
working on your setup with this patch, yes..?

Thanks!

--nab
