From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/2] be2iscsi : Update to 10.4.114.0
Date: Fri, 26 Sep 2014 14:06:57 -0500
Message-ID: <5425B951.7020207@cs.wisc.edu>
References: <ac10c6c1-57b3-4d39-b5be-7af9fb343e95@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46432 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbaIZTHG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2014 15:07:06 -0400
In-Reply-To: <ac10c6c1-57b3-4d39-b5be-7af9fb343e95@CMEXHTCAS2.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john-n@emulex.com>, linux-scsi@vger.kernel.org

On 09/26/2014 02:13 PM, John Soni Jose wrote:
>  This patchset updates be2iscsi driver to 10.4.114.0
>  These patches are based on for-next branch of scsi.git.
> 
> John Soni Jose (2):
>   be2iscsi : Fix kernel panic during reboot/shutdown
>   be2iscsi : Bump the driver version
> 
>  drivers/scsi/be2iscsi/be_main.c |    2 +-
>  drivers/scsi/be2iscsi/be_main.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 

Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

Christoph, since this was only two patches I was not sure if you wanted
me to round it up with the other iscsi patches I have for 3.18 (I only
have 2).
