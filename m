From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 37/43] hpsa: use block layer tag for command allocation
Date: Fri, 17 Apr 2015 15:50:35 +0200
Message-ID: <55310FAB.6060306@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416135003.30238.51835.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934027AbbDQNui (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:50:38 -0400
In-Reply-To: <20150416135003.30238.51835.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:50 PM, Don Brace wrote:
> From: Webb Scales <webbnh@hp.com>
>
> Rework slave allocation:
>   - separate the tagging support setup from the hostdata setup
>   - make the hostdata setup act consistently when the lookup fails
>   - make the hostdata setup act consistently when the device is not added
>   - set up the queue depth consistently across these scenarios
>   - if the block layer mq support is not available, explicitly enable and
>     activate the SCSI layer tcq support (and do this at allocation-time so
>     that the tags will be available for INQUIRY commands)
>
> Tweak slave configuration so that devices which are masked are also
> not attached.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Webb Scales <webbnh@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

