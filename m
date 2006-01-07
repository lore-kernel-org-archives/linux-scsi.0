From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [2.6 patch] drivers/scsi/qla2xxx/Kconfig: two fixes
Date: Sat, 7 Jan 2006 16:50:09 -0700
Message-ID: <20060107235009.GH19769@parisc-linux.org>
References: <20060106163401.GP12131@stusta.de> <20060106211241.GG13844@andrew-vasquezs-powerbook-g4-15.local> <20060106230935.GC3774@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:20427 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1161071AbWAGXuJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 7 Jan 2006 18:50:09 -0500
Content-Disposition: inline
In-Reply-To: <20060106230935.GC3774@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Jan 07, 2006 at 12:09:35AM +0100, Adrian Bunk wrote:
> Due to the change of SCSI_QLA2XXX to a user-visible option that builds 
> the driver, this means that suddenly after upgrading the kernel and 
> running "make oldconfig" a SCSI driver gets built the user never 
> selected.
> 
> Do you have any suggestions for a new name?
> We could e.g. name it SCSI_QLAXXXX since the driver also supports 
> 6312/6322, or name it simply SCSI_QLA.

SCSI_QLOGIC_FC?  Or does this driver handle SAS too?
