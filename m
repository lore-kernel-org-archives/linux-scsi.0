From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [2.6 patch] drivers/scsi/qla2xxx/Kconfig: two fixes
Date: Fri, 6 Jan 2006 13:12:41 -0800
Message-ID: <20060106211241.GG13844@andrew-vasquezs-powerbook-g4-15.local>
References: <20060106163401.GP12131@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:29947 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S932510AbWAFVMo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2006 16:12:44 -0500
Content-Disposition: inline
In-Reply-To: <20060106163401.GP12131@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 06 Jan 2006, Adrian Bunk wrote:

> This patch contains the following fixes for 
> drivers/scsi/qla2xxx/Kconfig:
> - add a help text for SCSI_QLA2XXX_EMBEDDED_FIRMWARE
> - the firmware modules must depend on SCSI_QLA2XXX to prevent
>   illegal configurations like SCSI_QLA2XXX=m, SCSI_QLA21XX=y
> 
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Ack.

--
Andrew Vasquez
