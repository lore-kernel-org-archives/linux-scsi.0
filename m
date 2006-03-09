From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [SCSI] Make sgiwd93_detect and sgiwd93_detect static.
Date: Thu, 9 Mar 2006 07:44:15 -0700
Message-ID: <20060309144415.GS7301@parisc-linux.org>
References: <20060309143513.GA11531@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:933 "EHLO palinux.hppa")
	by vger.kernel.org with ESMTP id S1751537AbWCIOoR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2006 09:44:17 -0500
Content-Disposition: inline
In-Reply-To: <20060309143513.GA11531@linux-mips.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-scsi@vger.kernel.org

On Thu, Mar 09, 2006 at 02:35:13PM +0000, Ralf Baechle wrote:
> Nothing outside sgiwd93.c references them.

Any plans to migrate sgiwd93.c away from the scsi_module.c horribleness?
