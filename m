From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/19] lpfc 10.4.8000.0: Update lpfc version to driver
 version 10.4.8000.0
Date: Thu, 4 Sep 2014 22:35:32 -0700
Message-ID: <20140905053532.GA10457@infradead.org>
References: <1409763288.12357.0.camel@myfc17>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45936 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaIEFfd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 01:35:33 -0400
Content-Disposition: inline
In-Reply-To: <1409763288.12357.0.camel@myfc17>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org

I've applied the series, but for next time can you make sure to follow
the proper format:

 - remove the version number in every subject line
 - patches you resend from an original author should be unchanged,
   except that the From: lines moves into the mail body
 - patches that you send on with your maintainer hat on should be
   signed off by you, not just reviewed.

not strictly required, but making my life a lot easier would be if all
patches are sent by reply to the original mail.  git-send-email does
this, and it seems like the Emulex division supporting be2scsi has found
a way to use it with the corporate email servers.

