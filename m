From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] bfa: fix compilation warning in powerpc (resend)
Date: Wed, 21 Apr 2010 16:12:17 -0700
Message-ID: <20100421161217.60d5654b.akpm@linux-foundation.org>
References: <1271186549-642-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1271186549-642-1-git-send-email-huangj@brocade.com>
Sender: linux-next-owner@vger.kernel.org
To: Jing Huang <huangj@Brocade.com>
Cc: sfr@canb.auug.org.au, James.Bottomley@suse.de, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kgudipat@Brocade.com, rvadivel@Brocade.com, vravindr@Brocade.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 13 Apr 2010 12:22:29 -0700
Jing Huang <huangj@Brocade.com> wrote:

> Fix the compilation warning in powerpc.

When fixing a warning, please quote that warning in the patch description!

<does a cross-build>

It seems that you're referring to this:

drivers/scsi/bfa/bfa_ioc.c: In function 'bfa_ioc_msgget':
drivers/scsi/bfa/bfa_ioc.c:1331: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_ct.c: In function 'bfa_ioc_ct_notify_hbfail':
drivers/scsi/bfa/bfa_ioc_ct.c:177: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_ct.c:180: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_ct.c: In function 'bfa_ioc_ct_pll_init':
drivers/scsi/bfa/bfa_ioc_ct.c:381: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_ct.c: In function 'bfa_ioc_ct_ownership_reset':
drivers/scsi/bfa/bfa_ioc_ct.c:421: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_cb.c: In function 'bfa_ioc_cb_notify_hbfail':
drivers/scsi/bfa/bfa_ioc_cb.c:99: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_cb.c: In function 'bfa_ioc_cb_ownership_reset':
drivers/scsi/bfa/bfa_ioc_cb.c:272: warning: value computed is not used


> The same change also fixes endian
> issue we found in powerpc test.

When fixing a bug, please fully describe the bug!

If this driver has "endian issues" on powerpc then it's quite possible
that this is a running-around-with-hair-on-fire,
must-backport-to-2.6.33.x bugfix.

But how would I know?  You didn't tell me!
