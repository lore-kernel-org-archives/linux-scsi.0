From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 30/43] hpsa: performance tweak for hpsa_scatter_gather()
Date: Fri, 17 Apr 2015 15:43:46 +0200
Message-ID: <55310E12.6070709@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134926.30238.26368.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbbDQNoJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:44:09 -0400
In-Reply-To: <20150416134926.30238.26368.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:49 PM, Don Brace wrote:
> From: Webb Scales <webbnh@hp.com>
>
> Divide the loop in hpsa_scatter_gather() into two, one for the initial SG list
> and a second one for the chained list, if any.  This allows the conditional
> check which resets the indicies for the chained list to be performed outside
> the loop instead of being done on every iteration inside the loop.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Webb Scales <webbnh@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas


