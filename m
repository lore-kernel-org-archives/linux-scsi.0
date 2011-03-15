From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC-v2 07/12] iscsi-target: Add CHAP Authentication support
	using libcrypto
Date: Tue, 15 Mar 2011 11:24:04 +0100
Message-ID: <20110315102404.GB24496@lst.de>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org> <1300103829-10337-8-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1300103829-10337-8-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 14, 2011 at 04:57:04AM -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds support for libcrypto md5 based iSCSI CHAP authentication
> support for iscsi_target_mod.  This includes support for mutual and one-way
> NodeACL authentication for SessionType=Normal and SessionType=Discovery
> via /sys/kernel/config/target/iscsi.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/iscsi/iscsi_auth_chap.c |  502 ++++++++++++++++++++++++++++++++
>  drivers/target/iscsi/iscsi_auth_chap.h |   33 ++
>  2 files changed, 535 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/target/iscsi/iscsi_auth_chap.c
>  create mode 100644 drivers/target/iscsi/iscsi_auth_chap.h

Why aren't these files named iscsi_target_* like most others?  If you prefix
all files in a module please do it consistently, or alternatively just
drop the prefix altogether.
