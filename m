From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 21/43] hpsa: do not check cmd_alloc return value -
 it cannnot return NULL
Date: Fri, 17 Apr 2015 15:32:35 +0200
Message-ID: <55310B73.1070504@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134838.30238.97749.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbbDQNci (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:32:38 -0400
In-Reply-To: <20150416134838.30238.97749.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:48 PM, Don Brace wrote:
> From: Robert Elliott <elliott@hp.com>
>
> cmd_alloc can no longer return NULL, so don't check for NULL any more
> (which is unreachable code).
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

