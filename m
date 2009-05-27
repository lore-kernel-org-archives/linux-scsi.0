From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 18/24] mpt fusion: [2.6.30-rc6] Code Cleanup patch
Date: Wed, 27 May 2009 17:53:43 +0000
Message-ID: <1243446823.6067.40.camel@localhost.localdomain>
References: <20090522110832.GL16331@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38796 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932761AbZE0Rxo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 May 2009 13:53:44 -0400
In-Reply-To: <20090522110832.GL16331@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Fri, 2009-05-22 at 16:38 +0530, Kashyap, Desai wrote:
> +
> +#define mpt_sg_next    sg_next

So everything in here looks vaguely OK (modulo a few over wrapped
prints) except this ... what's the point of adding this obfuscation?

James


