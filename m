From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_devinfo: update Hitachi entries
Date: Mon, 01 Jun 2009 16:54:35 +0000
Message-ID: <1243875275.4203.19.camel@mulgrave.int.hansenpartnership.com>
References: <4A2405FD.3000901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33179 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbZFAQyn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jun 2009 12:54:43 -0400
In-Reply-To: <4A2405FD.3000901@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Takahiro Yasui <tyasui@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2009-06-01 at 12:46 -0400, Takahiro Yasui wrote:
>  	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
> -	{"HITACHI", "OPEN-E", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
> +	{"HITACHI", "OPEN-", "*", BLIST_REPORTLUN2},

Can we drop the BLIST_ATTACH_PQ3?  It was there for not only to get the
sequential scan to work, but also so LUN0 would be registered with the
OS (I think for some control purpose) which would no longer happen.

James


