From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: 2.6.0-test9: scsi_dev_flags
Date: Sat, 1 Nov 2003 09:11:03 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031101091103.A19827@beaverton.ibm.com>
References: <20031026144741.A4326@flint.arm.linux.org.uk> <20031026083850.A15515@beaverton.ibm.com> <20031101131309.A31429@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:15602 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263178AbTKARLy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Nov 2003 12:11:54 -0500
Content-Disposition: inline
In-Reply-To: <20031101131309.A31429@flint.arm.linux.org.uk>; from rmk@arm.linux.org.uk on Sat, Nov 01, 2003 at 01:13:09PM +0000
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-scsi@vger.kernel.org

On Sat, Nov 01, 2003 at 01:13:09PM +0000, Russell King wrote:
> Ok, I've tried scsi_mod.scsi_dev_flags= and the kernel whinges:
> 
> Unknown boot option `scsi_mod.scsi_dev_flags=SyQuest:SQ3270S:4096': ignoring

Russel -

Sorry I got that wrong, it is scsi_mod.dev_flags.

Does the drive work fine with 2.4?

-- Patrick Mansfield
