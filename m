From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Tue, 13 Apr 2004 23:26:47 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0404132325190.16680-100000@poirot.grange>
References: <407A7F9B.2030604@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:43169 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263759AbUDMV0v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 17:26:51 -0400
In-Reply-To: <407A7F9B.2030604@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christian Roessner <info@roessner-net.com>, linux-scsi@vger.kernel.org

On Mon, 12 Apr 2004, Jeff Garzik wrote:

> Would be nice if we could kill the non-standard types (ULONG, etc.) from
> the driver.

Sure, the diff it would be quite big though, so, it would deserve a
separate patch, IMHO.

Thanks
Guennadi
---
Guennadi Liakhovetski


