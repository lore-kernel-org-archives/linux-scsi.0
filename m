From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dc395x: dynamically map scatter-gather for PIO (take 2)
Date: Fri, 21 Apr 2006 23:42:43 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0604212341260.3237@poirot.grange>
References: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
 <20060413132932.31871824.rdunlap@xenotime.net> <Pine.LNX.4.60.0604132256490.4711@poirot.grange>
 <20060419172733.d61e3365.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:21229 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S964801AbWDUVmu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Apr 2006 17:42:50 -0400
In-Reply-To: <20060419172733.d61e3365.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Sebastian@schnapsleichen.de, roubert@df.lth.se, lenehan@twibble.org

On Wed, 19 Apr 2006, Randy.Dunlap wrote:

> I have a patch that seems to work for the data-in phase of the
> aha152x (_cs) driver.  However, the data-out phase is causing
> data corruption.  (I'm only using it on a test target, so no big
> deal.)

Could you provide some detail? Your current patch? Maybe try to debug the 
data corruption if it is reproducible / predictable?

Thanks
Guennadi
---
Guennadi Liakhovetski
