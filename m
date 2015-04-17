From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 09/43] hpsa: factor out hpsa_init_cmd function
Date: Fri, 17 Apr 2015 15:26:05 +0200
Message-ID: <553109ED.3060608@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134730.30238.62412.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933955AbbDQNr2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:47:28 -0400
In-Reply-To: <20150416134730.30238.62412.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:47 PM, Don Brace wrote:
> From: Stephen Cameron <stephenmcameron@gmail.com>
>
> Factor out hpsa_cmd_init from cmd_alloc().  We also need
> this for resubmitting commands down the default RAID path
> when they have returned from the ioaccel paths with errors.
>
> In particular, reinitialize the cmd_type and busaddr fields as these
> will not be correct for submitting down the RAID stack path
> after ioaccel command completion.
>
> This saves time when submitting commands.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

