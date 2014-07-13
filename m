From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3 0/7] Drivers: scsi: storvsc: Bug fixes and improvements
Date: Sun, 13 Jul 2014 02:51:02 -0700
Message-ID: <20140713095102.GB19682@infradead.org>
References: <1405183684-23928-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43926 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaGMJvF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jul 2014 05:51:05 -0400
Content-Disposition: inline
In-Reply-To: <1405183684-23928-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: jasowang@redhat.com, apw@canonical.com, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org

The series looks good to me, although I'll probably put the commit
message for the timer patch into the comment for the eh_timed_out
handler.

Can I get another set of reviews?  I've seen Olaf has put them into the
SLES tree, so I'd expect he's done a review already?

