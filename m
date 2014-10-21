From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [GIT PULL] osd: Boaz Harrosh - change of email
Date: Tue, 21 Oct 2014 23:04:12 +0200
Message-ID: <1413925452.5312.3.camel@jarvis.int.hansenpartnership.com>
References: <5446682C.50201@electrozaur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5446682C.50201-rh7Tgz9RNieUD9Wbbkgo/g@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <ooo-rh7Tgz9RNieUD9Wbbkgo/g@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, open-osd <osd-dev-yNzVSZO3znNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, NFS list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-10-21 at 17:05 +0300, Boaz Harrosh wrote:
> Hi Sir Linus
> 
> A small administrative stuff, was on vacation and the old email bounced on me.
> I was hoping to still make the 3 weeks merge window, but it was 2 weeks at the
> end.
> Your call if to make this wait for next window. Needless to say that it is
> ZERO risk, just change of email.
> 
> Based on commit [bfe01a5b] Linux 3.17
> 
> 3 patches available in the git repository at:
> 
>   git://git.open-osd.org/linux-open-osd.git for-linus
> 
> for you to fetch changes up to 1fa3a002b2546c42c343c77c144871285896ced5:
> 
>   Boaz Harrosh - fix email in Documentation (2014-10-19 20:36:36 +0300)
> 
> ----------------------------------------------------------------
> Boaz Harrosh (3):
>       MAINTAINERS: Change Boaz Harrosh's email
>       Boaz Harrosh - Fix broken email address
>       Boaz Harrosh - fix email in Documentation
> 
>  Documentation/scsi/osd.txt          | 3 +--
>  MAINTAINERS                         | 2 +-
>  drivers/scsi/osd/Kbuild             | 2 +-
>  drivers/scsi/osd/Kconfig            | 2 +-
>  drivers/scsi/osd/osd_debug.h        | 2 +-
>  drivers/scsi/osd/osd_initiator.c    | 4 ++--
>  drivers/scsi/osd/osd_uld.c          | 4 ++--
>  fs/exofs/Kbuild                     | 2 +-
>  fs/exofs/common.h                   | 2 +-
>  fs/exofs/dir.c                      | 2 +-
>  fs/exofs/exofs.h                    | 2 +-
>  fs/exofs/file.c                     | 2 +-
>  fs/exofs/inode.c                    | 2 +-
>  fs/exofs/namei.c                    | 2 +-
>  fs/exofs/ore.c                      | 4 ++--
>  fs/exofs/ore_raid.c                 | 2 +-
>  fs/exofs/ore_raid.h                 | 2 +-
>  fs/exofs/super.c                    | 2 +-
>  fs/exofs/symlink.c                  | 2 +-
>  fs/exofs/sys.c                      | 2 +-
>  fs/nfs/objlayout/objio_osd.c        | 2 +-
>  fs/nfs/objlayout/objlayout.c        | 2 +-
>  fs/nfs/objlayout/objlayout.h        | 2 +-
>  fs/nfs/objlayout/pnfs_osd_xdr_cli.c | 2 +-
>  include/linux/pnfs_osd_xdr.h        | 2 +-
>  include/scsi/osd_initiator.h        | 2 +-
>  include/scsi/osd_ore.h              | 2 +-
>  include/scsi/osd_protocol.h         | 4 ++--
>  include/scsi/osd_sec.h              | 2 +-
>  include/scsi/osd_sense.h            | 2 +-
>  include/scsi/osd_types.h            | 2 +-
>  31 files changed, 35 insertions(+), 36 deletions(-)

This is a bit of an unnecessary massive churn.  No one expects the
author named in the file to stay up to date, especially because the
@domain.com usually credits the company who paid for the code, so it's
left in as a kind of mark of respect for them.  I'm not saying it
applies in your case, just that it creates the common expectation of
in-file authors needing to be traced through the MAINTAINERS file.

Could you not just update the MAINTAINERS file only, like everyone else?

James


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
