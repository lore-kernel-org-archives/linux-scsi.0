From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: fix sparse warnings in FlashPoint.c
Date: Mon, 08 Aug 2011 15:59:21 -0500
Message-ID: <1312837162.13854.2.camel@mulgrave>
References: <20110808134302.128126e1.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54503 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754224Ab1HHU70 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2011 16:59:26 -0400
In-Reply-To: <20110808134302.128126e1.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: scsi <linux-scsi@vger.kernel.org>

On Mon, 2011-08-08 at 13:43 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix sparse warnings in FlashPoint.c:
> 
> drivers/scsi/FlashPoint.c:2160:37: warning: non-ANSI function declaration of function 'FPT_SccbMgrTableInitAll'
> drivers/scsi/FlashPoint.c:906:9: warning: Using plain integer as NULL pointer
> drivers/scsi/FlashPoint.c:907:53: warning: Using plain integer as NULL pointer
> drivers/scsi/FlashPoint.c:922:1: warning: Using plain integer as NULL pointer

Flashpoint is about as defunct as they come, so it only gets provable
and major bug fixes until it gets ejected from the tree.

James


