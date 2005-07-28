From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fix up qla2xxx configuration bogosity
Date: Thu, 28 Jul 2005 09:53:48 -0400
Message-ID: <1122558828.5132.8.camel@mulgrave>
References: <20050728051058.GA567@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261447AbVG1N6W@vger.kernel.org>
In-Reply-To: <20050728051058.GA567@plap.qlogic.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2005-07-27 at 22:10 -0700, Andrew Vasquez wrote:
> Would you also apply the attached patch which adds the appropriate
> FW_LOADER pre-requisite and a separate entry for ISP24xx support.

That's what I see reading the code; however, it looks like it's *only*
the 24xx that needs it (qla24xx_load_risc_hotplug).  The patch below
pulls in the FW loader for every qlogic fibre driver, not just the
qla24xx; is there a reason for doing this?

James
