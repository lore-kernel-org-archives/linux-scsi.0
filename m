From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v2 4/9] target/pr: cleanup core_scsi3_pr_seq_non_holder
Date: Fri, 22 May 2015 10:26:59 +0200
Message-ID: <20150522082659.GB24640@lst.de>
References: <1432275071-28882-1-git-send-email-nab@daterainc.com> <1432275071-28882-5-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60657 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756229AbbEVI1B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 May 2015 04:27:01 -0400
Content-Disposition: inline
In-Reply-To: <1432275071-28882-5-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Oh, you've actually go it - still would make sense to move it the beginning of
the series.
