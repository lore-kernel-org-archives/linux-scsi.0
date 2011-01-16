From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
Date: Sun, 16 Jan 2011 13:44:33 -0800
Message-ID: <1295214273.22813.48.camel@haakon2.linux-iscsi.org>
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
	 <AANLkTikmyDsq37e6D1FXGXTJ7zztsnxfZvPBBHqO_Tch@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38376 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab1APVoi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Jan 2011 16:44:38 -0500
In-Reply-To: <AANLkTikmyDsq37e6D1FXGXTJ7zztsnxfZvPBBHqO_Tch@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>, Randy Dunlap <randy.dunlap@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>

On Sun, 2011-01-16 at 09:54 -0800, Linus Torvalds wrote:
> On Sat, Jan 15, 2011 at 1:10 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > This patch changes configfs to select SYSFS to fix the following:
> >
> > warning: (TARGET_CORE && GFS2_FS) selects CONFIGFS_FS which has unmet direct dependencies (SYSFS)
> 
> I'm ok with this part. But:
> 
> > This patch also fixes whitespace breakage in the 'help' section.
> 
> This is just bogus. The help text is _supposed_ to have that extra
> indentation so that it stands out from the rest of the Kconfig stuff.
> 

Ahh, thanks for the clarification here.   At some point I saw a patch
that did make this change, and it stuck with me that it was the
preferred method.  This won't happen again.

The updated patch to keep the extra indentation for configfs, along with
the three extra 'depends CONFIGFS_FS' patches from yesterday are
available in a pullable branch against this afternoon's
linux-2.6.git/master here:

git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-linus

Please let me know if you have any questions,

--nab

Nicholas Bellinger (4):
  configfs: change depends -> select SYSFS
  net: Make NETCONSOLE_DYNAMIC depend on CONFIGFS_FS
  dlm: Make DLM depend on CONFIGFS_FS
  ocfs2: Make OCFS2_FS depend on CONFIGFS_FS

 drivers/net/Kconfig |    3 +--
 fs/configfs/Kconfig |    4 ++--
 fs/dlm/Kconfig      |    3 +--
 fs/ocfs2/Kconfig    |    3 +--
 4 files changed, 5 insertions(+), 8 deletions(-)


