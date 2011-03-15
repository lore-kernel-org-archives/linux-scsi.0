From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v2 07/12] iscsi-target: Add CHAP Authentication support
	using libcrypto
Date: Tue, 15 Mar 2011 15:56:37 -0700
Message-ID: <1300229797.28255.317.camel@haakon2.linux-iscsi.org>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>
	 <1300103829-10337-8-git-send-email-nab@linux-iscsi.org>
	 <20110315102404.GB24496@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110315102404.GB24496@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-03-15 at 11:24 +0100, Christoph Hellwig wrote:
> On Mon, Mar 14, 2011 at 04:57:04AM -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds support for libcrypto md5 based iSCSI CHAP authentication
> > support for iscsi_target_mod.  This includes support for mutual and one-way
> > NodeACL authentication for SessionType=Normal and SessionType=Discovery
> > via /sys/kernel/config/target/iscsi.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/iscsi/iscsi_auth_chap.c |  502 ++++++++++++++++++++++++++++++++
> >  drivers/target/iscsi/iscsi_auth_chap.h |   33 ++
> >  2 files changed, 535 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/target/iscsi/iscsi_auth_chap.c
> >  create mode 100644 drivers/target/iscsi/iscsi_auth_chap.h
> 
> Why aren't these files named iscsi_target_* like most others?  If you prefix
> all files in a module please do it consistently, or alternatively just
> drop the prefix altogether.
> 

This where shared amounst initiator code at one point..  Renaming to
iscsi_target_auth now.

Thanks,

--nab
