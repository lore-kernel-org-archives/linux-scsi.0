From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: question on sd_prep_fn()
Date: Mon, 16 Jan 2012 18:04:53 +0400
Message-ID: <1326722693.2872.24.camel@dabdike>
References: <201201161425.28952.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43169 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754025Ab2APOE4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2012 09:04:56 -0500
In-Reply-To: <201201161425.28952.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2012-01-16 at 14:25 +0100, Oliver Neukum wrote:
> could someone explain to me in which context sd_prep_fn() is called?

Any.  Well to be more precise any from Softirq on down; so no sleeping
functions, if that's what you're asking about.

James


