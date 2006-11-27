From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [-mm patch] make qla2x00_reg_remote_port() static
Date: Mon, 27 Nov 2006 09:22:38 -0800
Message-ID: <20061127172238.GA21083@andrew-vasquezs-computer.local>
References: <20061123021703.8550e37e.akpm@osdl.org> <20061124014601.GQ3557@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:33466 "EHLO
	avexch1.qlogic.com") by vger.kernel.org with ESMTP id S1758411AbWK0RWj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Nov 2006 12:22:39 -0500
Content-Disposition: inline
In-Reply-To: <20061124014601.GQ3557@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-driver@qlogic.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Fri, 24 Nov 2006, Adrian Bunk wrote:

> On Thu, Nov 23, 2006 at 02:17:03AM -0800, Andrew Morton wrote:
> >...
> > Changes since 2.6.19-rc5-mm2:
> >...
> >  git-scsi-misc.patch
> >...
> >  git trees
> >...
> 
> qla2x00_reg_remote_port() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
