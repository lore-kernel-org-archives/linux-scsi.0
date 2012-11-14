From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 01/19] be2iscsi: Fix the issue with soft reset.
Date: Tue, 13 Nov 2012 18:26:39 -0800
Message-ID: <1352859999.28921.0.camel@dabdike>
References: <a1ed23df-f582-4c7b-9d85-0468559c645a@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56034 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754789Ab2KNHEO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Nov 2012 02:04:14 -0500
In-Reply-To: <a1ed23df-f582-4c7b-9d85-0468559c645a@CMEXHTCAS2.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john-n@emulex.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, Minh Tran <minhduc.tran@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

On Sat, 2012-10-20 at 04:41 +0530, John Soni Jose wrote:
> From: Minh Tran <minhduc.tran@emulex.com>
> 
>  Fixed soft_reset problem which driver modified
>  all 32bit before a write on second pass.
> 
> Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

I'll put this in, this time, but please remember that if you send me a
patch, it needs your signoff as well.

James



