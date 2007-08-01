From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi_transport_srp: remove tgt dependencies
Date: Wed, 01 Aug 2007 11:20:04 -0500
Message-ID: <1185985204.3468.83.camel@localhost.localdomain>
References: <20070801051532F.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55049 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756243AbXHAQUG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 12:20:06 -0400
In-Reply-To: <20070801051532F.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Thu, 2007-08-02 at 00:20 +0900, FUJITA Tomonori wrote:
> Hopefully, this works. Is there an easier way to remove tgt
> dependencies in scsi_transport_srp?
[...]
> +	depends on SCSI_SRP_ATTRS
> +	depends on SCSI_TGT = y || SCSI_TGT = SCSI_SRP_ATTRS

I asked the same thing for the same problem in the libata in libsas
config varible.  Didn't get an answer though ... but my solution was the
same as yours, if it helps.

James


