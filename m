From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
Date: Sun, 16 Jan 2011 14:11:05 +0100
Message-ID: <20110116141105.59e5b3a2@stein>
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>, Randy Dunlap <randy.dunlap@oracle.com>, James Bottomley <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Jan 15 Nicholas A. Bellinger wrote:
> This patch changes configfs to select SYSFS to fix the following:
> 
> warning: (TARGET_CORE && GFS2_FS) selects CONFIGFS_FS which has unmet direct dependencies (SYSFS)

Why don't you fix target-core's Kconfig instead?

> This patch also fixes whitespace breakage in the 'help' section.

There is no whitespace breakage in fs/configfs/Kconfig.
-- 
Stefan Richter
-=====-==-== ---= =----
http://arcgraph.de/sr/
