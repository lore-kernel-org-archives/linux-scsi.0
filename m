From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/2] be2iscsi: Bug Fixes for starting with Non-Zero cid
 etc
Date: Tue, 03 Nov 2009 17:39:40 -0600
Message-ID: <1257291580.2454.40.camel@mulgrave.site>
References: <20091103231758.GA2449@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44079 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZKCXjl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 18:39:41 -0500
In-Reply-To: <20091103231758.GA2449@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Wed, 2009-11-04 at 04:48 +0530, Jayamohan Kallickal wrote:
> This patch contains fixes for condition where the first
> cid is Non-Zero as well as other bugs.

So traditionally one patch per bug fix, please (and fully described).

Also traditionally bug fixes go in the scsi-rc-fixes-2.6 tree for
immediate inclusion ... you've got this paired with an enhancement that
would go through scsi-misc-2.6.

James


