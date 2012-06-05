From: Martin Pitt <martin.pitt@ubuntu.com>
Subject: Re: [PATCH 1/1] [SCSI] scsi_debug: Add "removable" parameter
Date: Tue, 5 Jun 2012 19:39:30 +0200
Message-ID: <20120605173930.GO3043@piware.de>
References: <20120605072528.GE3043@piware.de>
 <20120605072737.GF3043@piware.de>
 <4FCE30DE.6090903@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FCE30DE.6090903@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, David Zeuthen <zeuthen@gmail.com>, Kay Sievers <kay@vrfy.org>
List-Id: linux-scsi@vger.kernel.org

Randy Dunlap [2012-06-05  9:16 -0700]:
> so why not make it a bool instead of an int value?

Just like the obsolete printk KERN_ERR and the overly long lines (see
my intro mail) I wanted to be consistent with the existing boolean
options (the other flags also use an int).

However, I don't mind much either way; if it is preferred, I can
send a patch with int =E2=86=92 bool.

Thanks,

Martin

--=20
Martin Pitt                        | http://www.piware.de
Ubuntu Developer (www.ubuntu.com)  | Debian Developer  (www.debian.org)
