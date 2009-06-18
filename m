From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] tmscsim: Fix big left-shifts of unsigned char
Date: Thu, 18 Jun 2009 14:45:42 +0000
Message-ID: <1245336342.7586.4.camel@mulgrave.site>
References: <4A3A2FA2.60005@gmail.com>
	 <1245330204.4773.10.camel@mulgrave.site>
	 <20090618131632.GZ19977@parisc-linux.org> <4A3A40C9.9020900@panasas.com>
	 <20090618133613.GA19977@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53629 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754816AbZFROpq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Jun 2009 10:45:46 -0400
In-Reply-To: <20090618133613.GA19977@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Roel Kluin <roel.kluin@gmail.com>, garloff@suse.de, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Thu, 2009-06-18 at 07:36 -0600, Matthew Wilcox wrote:
> For one, Linux doesn't support an ILP64 model.  I32LP64 and ILP32 are
> the only two models supported.

Heh ... embedded is easy to forget.  I believe, for reasons I have had
explained at length but understandably don't wish to go through again,
Sony has an IP32L64 model for the PS3 which causes all sorts of erm
problems.

James


