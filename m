From: Dave Jones <davej@suse.de>
Subject: Re: [PATCH] /proc/scsi/map
Date: Thu, 20 Jun 2002 17:36:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020620173654.O29373@suse.de>
References: <200206200711.RAA10165@thucydides.inspired.net.au> <Pine.LNX.4.44.0206200800260.8012-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0206200800260.8012-100000@home.transmeta.com>; from torvalds@transmeta.com on Thu, Jun 20, 2002 at 08:13:22AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Martin Schwenke <martin@meltin.net>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>

On Thu, Jun 20, 2002 at 08:13:22AM -0700, Linus Torvalds wrote:
 > and then look at the whole glory in some graphical file manager to get a
 > view of the tree (actually, most file managers are somewhat confused about
 > the fact that the directory counts don't reflect sub-directories, so you
 > may have to open the subdirectories by hand, whatever. That's a bug.
 > Should be fixed. I'm cc'ing Pat)

Is this the same bug that causes this wierdo..

(davej@mesh:drivers)$ pwd
/driver/bus/pci/drivers
(davej@mesh:drivers)$ ls -l
ls: VIA 82C686A/B: No such file or directory
total 0
drwxr-xr-x    1 root     root            0 Jun 19 22:34 3c59x/
drwxr-xr-x    1 root     root            0 Jun 19 22:34 Sound Fusion CS46xx/
drwxr-xr-x    1 root     root            0 Jun 19 22:34 bttv/
drwxr-xr-x    1 root     root            0 Jun 19 22:34 parport_pc/
drwxr-xr-x    1 root     root            0 Jun 19 22:34 serial/

(Note the VIA line)

        Dave.

-- 
| Dave Jones.        http://www.codemonkey.org.uk
| SuSE Labs
