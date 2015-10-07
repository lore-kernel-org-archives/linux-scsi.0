From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/2] be2iscsi driver update to 10.6.0.1
Date: Wed, 07 Oct 2015 13:35:25 -0500
Message-ID: <561565ED.5090404@cs.wisc.edu>
References: <1440026071-27748-1-git-send-email-sony.john@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42543 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbbJGSfd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Oct 2015 14:35:33 -0400
In-Reply-To: <1440026071-27748-1-git-send-email-sony.john@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john@avagotech.com>, linux-scsi@vger.kernel.org

On 08/19/2015 06:14 PM, John Soni Jose wrote:
> This patch is generated against the for-next branch.
> 
> John Soni Jose (1):
>   be2iscsi: Bump the driver version
> 
> John Soni Jose (1):
>   be2iscsi: Fix updating the next pointer during WRB posting
> 
>  drivers/scsi/be2iscsi/be_main.c |   62 +++++++++++++++++++++++++++++---------
>  drivers/scsi/be2iscsi/be_main.h |    7 ++--
>  drivers/scsi/be2iscsi/be_mgmt.c |   24 ++++++++++++--
>  drivers/scsi/be2iscsi/be_mgmt.h |    7 +++-
>  4 files changed, 76 insertions(+), 24 deletions(-)
> 

Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
