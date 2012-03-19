From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] dm-mpath: Clear map_context pointer when requeuing
Date: Mon, 19 Mar 2012 15:00:15 +0000
Message-ID: <20120319150015.GC4495@agk-dp.fab.redhat.com>
References: <1322663118-53387-1-git-send-email-hare@suse.de> <20111130144951.GA13775@redhat.com> <4ED6C67A.3060305@ce.jp.nec.com> <4ED8FA8F.20109@suse.de> <4EDCA1BD.1000708@ce.jp.nec.com> <4EDCEFFE.6080702@suse.de> <4EDD9DBD.7000603@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049Ab2CSPAf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Mar 2012 11:00:35 -0400
Content-Disposition: inline
In-Reply-To: <4EDD9DBD.7000603@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, dm-devel@redhat.com, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>

OK - I'm not taking this patch in its current form.

If there are still concerns about this, I would accept a BUG_ON() style patch
that consistently checks/clears the value of the field.

Alasdair

