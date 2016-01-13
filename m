From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [LSF/MM ATTEND][LSF/MM TOPIC] Multipath redesign
Date: Wed, 13 Jan 2016 11:08:22 +0000
Message-ID: <20160113110822.GC452@agk-dp.fab.redhat.com>
References: <56961493.5010901@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbcAMLIY (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 06:08:24 -0500
Content-Disposition: inline
In-Reply-To: <56961493.5010901@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, Junichi Nomura <j-nomura@ce.jp.nec.com>

On Wed, Jan 13, 2016 at 10:10:43AM +0100, Hannes Reinecke wrote:
> The overall idea is to break up the centralized multipath handling in 
> device-mapper (and multipath-tools) and delegate to the appropriate 
> sub-systems.
>
> Individually the plan is:

Could we start to drill down into each of these and categorise them in
terms of which parts of the stack are involved in the proposed change
and prioritise them in terms of likely amount of work and
cost/benefit/risk?  Some of them probably need some prototyping and
experimentation.

Alasdair

