From: Joe Perches <joe@perches.com>
Subject: RE: [PATCH] [SCSI] aacraid: Use kmemdup rather than duplicating its
 implementation
Date: Tue, 22 Nov 2011 07:56:50 -0800
Message-ID: <1321977410.1131.24.camel@Joe-Laptop>
References: <1321569820.1624.290.camel@localhost.localdomain>
	 <FC1F9E38C0703341A1A750524E2525A901978CD9@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A901978CD9@XYUS-EX22.xyus.xyratex.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Cc: Thomas Meyer <thomas@m3y3r.de>, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Achim Leubner <Achim_Leubner@pmc-sierra.com>, Mahesh Rajashekhara <Mahesh_Rajashekhara@pmc-sierra.com>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/drivers/scsi/aacraid/commctrl.c

On Tue, 2011-11-22 at 06:24 -0800, Mark Salyzyn wrote:
> This driver is maintained by Achim Leubner
> <Achim_Leubner@pmc-sierra.com> and Mahesh Rajashekhara
> <Mahesh_Rajashekhara@pmc-sierra.com>. I have added them so that either
> one of them can have the opportunity to respond.
 
Really?  MAINTAINERS has:

AACRAID SCSI RAID DRIVER
M:	Adaptec OEM Raid Solutions <aacraid@adaptec.com>
L:	linux-scsi@vger.kernel.org
W:	http://www.adaptec.com/
S:	Supported
F:	Documentation/scsi/aacraid.txt
F:	drivers/scsi/aacraid/

Should either or both Achim or Mahesh be added?
