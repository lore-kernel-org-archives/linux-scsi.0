From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: lsscsi-0.17 released
Date: Wed, 22 Feb 2006 17:06:02 +0100
Message-ID: <20060222160602.GB17473@merlin.emma.line.org>
References: <43FBA4CD.6000505@torque.net> <m34q2r93q2.fsf@merlin.emma.line.org> <43FC7CCB.4090508@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:28040 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932268AbWBVQGH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 11:06:07 -0500
Content-Disposition: inline
In-Reply-To: <43FC7CCB.4090508@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 22 Feb 2006, Douglas Gilbert wrote:

> Matthias Andree wrote:

> > Does this work around new incompatibilities in the kernel
> > or does this fix lsscsi bugs?
> 
> The former. In lk 2.6.16-rc1 the
> /sys/class/scsi_device/<hcil>/device/block symlink
> changed to ".../block:sd<x>" breaking lsscsi 0.16 (and
> earlier) and sg_map26 (in sg3_utils).

Heck, what was the reason for breaking userspace again?

Why would someone even consider using sysfs at all if it changes
incompatibly?

-- 
Matthias Andree
