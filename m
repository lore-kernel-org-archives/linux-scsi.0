From: Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] storvsc: use small sg_tablesize on x86
Date: Tue, 17 May 2016 15:07:38 +0200
Message-ID: <20160517130738.GA3059@aepfle.de>
References: <573A2CF9.5060702@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:24749 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbcEQNHr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2016 09:07:47 -0400
Content-Disposition: inline
In-Reply-To: <573A2CF9.5060702@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: KY Srinivasan <kys@microsoft.com>, James Bottomley <JBottomley@Odin.com>, Haiyang Zhang <haiyangz@microsoft.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, May 16, Joseph Salisbury wrote:


> > CONFIG_64BIT=y

> It doesn't appear this patch ever landed in Mainline.  Olaf, do you have
> plans to submit this patch?

Yes, will do.

Olaf
