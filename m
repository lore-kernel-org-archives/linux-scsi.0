From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] [SCSI] sd: workaround invalid OPTIMAL TRANSFER LENGTH
Date: Wed, 03 Apr 2013 16:38:08 -0400
Message-ID: <1365021488.9027.1.camel@localhost.localdomain>
References: <20130403202124.GB2197@redhat.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295Ab3DCUiK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Apr 2013 16:38:10 -0400
In-Reply-To: <20130403202124.GB2197@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On Wed, 2013-04-03 at 16:21 -0400, Mike Snitzer wrote:
> Workaround disk firmware that improperly sets OPTIMAL TRANSFER LENGTH to
> 0xFFFFFFFF (aka UINT_MAX or 4294967295U) by assuming this _optional_
> BLOCK LIMITS VPD field was not specified (0).
> 

Acked-by: Ewan D. Milne <emilne@redhat.com>


