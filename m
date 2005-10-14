From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 01/14] Big kfree NULL check cleanup - drivers/scsi
Date: Sat, 15 Oct 2005 00:19:18 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0510150015480.4632@kai.makisara.local>
References: <200510132122.09667.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:12932 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1750742AbVJNVTW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 17:19:22 -0400
In-Reply-To: <200510132122.09667.jesper.juhl@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@steeleye.com>

On Thu, 13 Oct 2005, Jesper Juhl wrote:

> This is the drivers/scsi/ part of the big kfree cleanup patch.
> 
> Remove pointless checks for NULL prior to calling kfree() in drivers/scsi/.
> 

> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

>  drivers/scsi/st.c                     |    3 --

Acked-by: Kai Makisara <kai.makisara@kolumbus.fi>

Thanks,
Kai
