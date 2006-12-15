From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 26/30] scsi: fix sense key MEDIUM ERROR processing and
	retry
Date: Fri, 15 Dec 2006 13:51:32 -0600
Message-ID: <1166212292.2846.52.camel@mulgrave.il.steeleye.com>
References: <200612042319.kB4NJpnD008810@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:42895 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753335AbWLOTvg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Dec 2006 14:51:36 -0500
In-Reply-To: <200612042319.kB4NJpnD008810@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: linux-scsi@vger.kernel.org, ltuikov@yahoo.com

On Mon, 2006-12-04 at 15:18 -0800, akpm@osdl.org wrote:
> From: Luben Tuikov <ltuikov@yahoo.com>
> 
> - If the device reports an uncorrectable MEDIUM ERROR, such as SK MEDIUM
>   ERROR, ASC UNRECOVERED READ ERR, AMNF DATA FIELD or RECORD NOT FOUND,
>   then: In scsi_check_sense() return SUCCESS so as to not retry -- the
>   error is uncorrectable -- this speeds up total processing time.

not with the extraneous patch piece at the bottom ... otherwise it's OK
with an updated changelog.

James


