From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/11] qla2xxx: Added interface to send ELS commands from
 driver.
Date: Fri, 3 Jul 2015 09:14:18 -0700
Message-ID: <20150703161418.GB32744@infradead.org>
References: <1435250031-20525-1-git-send-email-himanshu.madhani@qlogic.com>
 <1435250031-20525-10-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34675 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbbGCQOS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2015 12:14:18 -0400
Content-Disposition: inline
In-Reply-To: <1435250031-20525-10-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: jbottomley@parallels.com, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Why is this a binary attribute?  Needs an interface specific in
Documentation/ABI/ to start with, and a Ccto stable seems very
aggressive.

