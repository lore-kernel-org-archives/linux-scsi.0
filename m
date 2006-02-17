From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] sym53c8xx_2: Add bios_param to sym_glue.c
Date: Fri, 17 Feb 2006 07:37:18 -0700
Message-ID: <20060217143718.GS12822@parisc-linux.org>
References: <43F5D963.9080009@bfh.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43197 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751453AbWBQOhU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Feb 2006 09:37:20 -0500
Content-Disposition: inline
In-Reply-To: <43F5D963.9080009@bfh.ch>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seewer Philippe <philippe.seewer@bfh.ch>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Feb 17, 2006 at 03:10:43PM +0100, Seewer Philippe wrote:
> This patch adds the scsi common function bios_param to the sym53c8xx
> driver. For simplicity i just copied the code from the sym53c416 driver.

If the driver doesn't define bios_param, the scsi core calls
scsicam_bios_param, which seems to do everything this patch does,
and more.

A quick survey suggests that most drivers should have their bios_param
methods deleted.  Was there a particular problem you found with the
default scsicam_bios_param implementation?
