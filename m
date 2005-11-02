From: Chris Wright <chrisw@osdl.org>
Subject: Re: [stable] Re: [PATCH] scsi - Fix Broken Qlogic ISP2x00 Device Driver
Date: Wed, 2 Nov 2005 00:21:42 -0800
Message-ID: <20051102082142.GW5856@shell0.pdx.osdl.net>
References: <81083a450511012313v25e292duf7b64da0ebf07835@mail.gmail.com> <20051102080711.GB626@plapn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932647AbVKBIWD@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20051102080711.GB626@plapn>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Ashutosh Naik <ashutosh.naik@gmail.com>, support@qlogic.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

* Andrew Vasquez (andrew.vasquez@qlogic.com) wrote:
> On Wed, 02 Nov 2005, Ashutosh Naik wrote:
> 
> > This patch fixes the fact that although the scsi_transport_fc.h header
> > file is not included in qla_def.h, we still reference the function
> > fc_remote_port_unlock in the qlogic  ISP2x00 device driver ,
> > qla2xxx/qla_rscn.c
> 
> Perhaps for the stable tree (2.6.14.x) this fix is appropriate.  The
> scsi-misc-2.6.git tree already has codes which address this issue.

It's preferable to have that fix pending in scsi-misc for -stable.

thanks,
-chris
