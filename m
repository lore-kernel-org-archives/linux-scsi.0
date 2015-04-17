From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 06/43] hpsa: hpsa decode sense data for io and tmf
Date: Fri, 17 Apr 2015 15:23:24 +0200
Message-ID: <5531094C.5010508@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134714.30238.77926.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbbDQNX1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:23:27 -0400
In-Reply-To: <20150416134714.30238.77926.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:47 PM, Don Brace wrote:
> From: Stephen Cameron <stephenmcameron@gmail.com>
>
> In hba mode, we could get sense data in descriptor format so
> we need to handle that.
>
> It's possible for CommandStatus to have value 0x0D
> "TMF Function Status", which we should handle.  We will get
> this from a P1224 when aborting a non-existent tag, for
> example.  The "ScsiStatus" field of the errinfo field
> will contain the TMF function status value.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

