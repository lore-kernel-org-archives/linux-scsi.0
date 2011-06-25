From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 0/3] PM: Fix up interactions between system suspend/resume and runtime PM
Date: Sun, 26 Jun 2011 00:54:20 +0200
Message-ID: <201106260054.20578.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

The patches in this series are related to the interactions between system
suspend/resume and the I/O runtime PM framework.  We've had quite some
confusion and uncertainty in that area recently, so I'd like to clean it
up once and for all, so that everyone knows what the rules are and why
they are what they are.

[1/3] - Update documentation describing interactions between runtime PM and
        system suspend/resume.

[2/3] - Return special error code from runtime PM helers if runtime PM is
        disabled and make the SCSI error handling code take it into account.

[3/3] - Limit race conditions between runtime PM and system suspend/resume.

The patches are on top of the PM domains patchset I've just posted, which is
available from the git branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-domains

Thanks,
Rafael
    
