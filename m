From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] tmscsim: Fix big left-shifts of unsigned char
Date: Thu, 18 Jun 2009 09:03:24 -0400
Message-ID: <1245330204.4773.10.camel@mulgrave.site>
References: <4A3A2FA2.60005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50138 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614AbZFRND0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Jun 2009 09:03:26 -0400
In-Reply-To: <4A3A2FA2.60005@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: garloff@suse.de, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Thu, 2009-06-18 at 14:14 +0200, Roel Kluin wrote:
> -           dc390_laststatus |= bval << 24;
> +           dc390_laststatus |= (unsigned)bval << 24;

bval is already u8, thus unsigned, so the cast is a nop.

James


