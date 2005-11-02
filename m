From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] scsi - Fix Broken Qlogic ISP2x00 Device Driver
Date: Wed, 2 Nov 2005 00:07:11 -0800
Message-ID: <20051102080711.GB626@plapn>
References: <81083a450511012313v25e292duf7b64da0ebf07835@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932637AbVKBIHR@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <81083a450511012313v25e292duf7b64da0ebf07835@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ashutosh Naik <ashutosh.naik@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, support@qlogic.com, akpm@osdl.org, stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 02 Nov 2005, Ashutosh Naik wrote:

> This patch fixes the fact that although the scsi_transport_fc.h header
> file is not included in qla_def.h, we still reference the function
> fc_remote_port_unlock in the qlogic  ISP2x00 device driver ,
> qla2xxx/qla_rscn.c

Perhaps for the stable tree (2.6.14.x) this fix is appropriate.  The
scsi-misc-2.6.git tree already has codes which address this issue.

Regards,
Andrew Vasquez
