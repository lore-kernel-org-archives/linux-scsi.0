From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Conversion to generic boolean
Date: Mon, 28 Aug 2006 10:32:02 +0100
Message-ID: <20060828093202.GC8980@infradead.org>
References: <44EFBEFA.2010707@student.ltu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56251 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932464AbWH1Jcc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 05:32:32 -0400
Content-Disposition: inline
In-Reply-To: <44EFBEFA.2010707@student.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Aug 26, 2006 at 05:24:42AM +0200, Richard Knutsson wrote:
> Hello
> 
> Just would like to ask if you want patches for:

Total NACK to any of this boolean ididocy.  I very much hope you didn't
get the impression you actually have a chance to get this merged.

> 
> * (Most importent, may introduce bugs if left alone)
> Fixing boolean checking, ex:
> if (bool == FALSE)
> to
> if (!bool)

this one of course makes sense, but please do it without introducing
any boolean type.  Getting rid of all the TRUE/FALSE defines and converting
all scsi drivers to classic C integer as boolean semantics would be
very welcome janitorial work.

