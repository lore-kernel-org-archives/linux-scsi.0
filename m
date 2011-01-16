From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
Date: Sun, 16 Jan 2011 09:54:31 -0800
Message-ID: <AANLkTikmyDsq37e6D1FXGXTJ7zztsnxfZvPBBHqO_Tch@mail.gmail.com>
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>, Randy Dunlap <randy.dunlap@oracle.com>, James Bottomley <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 15, 2011 at 1:10 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> This patch changes configfs to select SYSFS to fix the following:
>
> warning: (TARGET_CORE && GFS2_FS) selects CONFIGFS_FS which has unmet direct dependencies (SYSFS)

I'm ok with this part. But:

> This patch also fixes whitespace breakage in the 'help' section.

This is just bogus. The help text is _supposed_ to have that extra
indentation so that it stands out from the rest of the Kconfig stuff.

                   Linus
