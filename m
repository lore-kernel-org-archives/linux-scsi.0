From: Oliver Neukum <oliver@neukum.org>
Subject: Re: question on sd_prep_fn()
Date: Mon, 16 Jan 2012 15:08:20 +0100
Message-ID: <201201161508.20195.oliver@neukum.org>
References: <201201161425.28952.oliver@neukum.org> <1326722693.2872.24.camel@dabdike>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:41637 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2APOGb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2012 09:06:31 -0500
In-Reply-To: <1326722693.2872.24.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

Am Montag, 16. Januar 2012, 15:04:53 schrieb James Bottomley:
> On Mon, 2012-01-16 at 14:25 +0100, Oliver Neukum wrote:
> > could someone explain to me in which context sd_prep_fn() is called?
> 
> Any.  Well to be more precise any from Softirq on down; so no sleeping
> functions, if that's what you're asking about.

Thank you, that is a clear answer.

	Regards
		Oliver
