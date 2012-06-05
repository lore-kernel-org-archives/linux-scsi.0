From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH 0/3 V2] alua updates
Date: Tue, 05 Jun 2012 12:38:03 -0400
Message-ID: <4FCE35EB.30109@redhat.com>
References: <1337364536-6425-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab2FEQiH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Jun 2012 12:38:07 -0400
In-Reply-To: <1337364536-6425-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

Hannes,

Do you have any feedback on these patches?

Thanks, Rob

On 05/18/2012 02:08 PM, Rob Evers wrote:
> A few minor updates to the previous alua patchset...
>
> alua: retry alua rtpg extended header for illegal request response:
> - Added entry condition to alua_rtpg ILLEGAL_REQUEST retry to avoid
>    possible infinite loop. Infinte loop could occur if an array fails
>    non-extended format rtpg request.
>
> - Fixed a few comment typos
>
> alua: backoff alua rtpg retry linearly vs. geometrically:
> - Added Martin George's signoff on patch as he contributed this.
>
> Rob Evers (3):
>    alua: implement 'implied transition timeout'
>    alua: retry alua rtpg extended header for illegal request response
>    alua: backoff alua rtpg retry linearly vs. geometrically
>
>   drivers/scsi/device_handler/scsi_dh_alua.c |   69 ++++++++++++++++++++++++----
>   include/scsi/scsi.h                        |    2 +
>   2 files changed, 62 insertions(+), 9 deletions(-)
>

