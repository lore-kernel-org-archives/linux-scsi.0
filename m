From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix warning and missing failure handling for
	scsi_add_host in aic7xxx driver
Date: Wed, 14 Dec 2005 00:20:29 -0800
Message-ID: <1134548429.3262.4.camel@mulgrave>
References: <200512140007.20046.jesper.juhl@gmail.com>
	 <1134534839.3133.2.camel@mulgrave>
	 <9a8748490512140002s8daf671h6db51bff1c06c834@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:5794 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932105AbVLNIUo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2005 03:20:44 -0500
In-Reply-To: <9a8748490512140002s8daf671h6db51bff1c06c834@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Daniel M. Eischen" <deischen@iworks.interworks.org>, Doug Ledford <dledford@redhat.com>

On Wed, 2005-12-14 at 09:02 +0100, Jesper Juhl wrote:
> I'll send a new patch later today when I get home from work.

Actually, the aic79xx has the identical problem, if you want to fix that
too ...

James


