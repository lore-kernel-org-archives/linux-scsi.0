From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
Date: Sun, 16 Jan 2011 13:53:27 -0800
Message-ID: <1295214807.22813.57.camel@haakon2.linux-iscsi.org>
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
	 <20110116141105.59e5b3a2@stein>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110116141105.59e5b3a2@stein>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>, Randy Dunlap <randy.dunlap@oracle.com>, James Bottomley <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2011-01-16 at 14:11 +0100, Stefan Richter wrote:
> On Jan 15 Nicholas A. Bellinger wrote:
> > This patch changes configfs to select SYSFS to fix the following:
> > 
> > warning: (TARGET_CORE && GFS2_FS) selects CONFIGFS_FS which has unmet direct dependencies (SYSFS)
> 
> Why don't you fix target-core's Kconfig instead?

The thought here was that since modern configfs is mounted
at /sys/kernel/config/, selecting SYSFS by default when building
CONFIGFS_FS made the most sense for existing configfs consumers.

> > This patch also fixes whitespace breakage in the 'help' section.
> 
> There is no whitespace breakage in fs/configfs/Kconfig.

Fixed in scsi-post-merge-2.6.git/for-linus.  Thanks for your comments!

--nab
