From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH] bsg: port to bidi
Date: Tue, 24 Apr 2007 13:28:09 -0400
Message-ID: <20070424172809.GD21882@osc.edu>
References: <20070424172713.GB21882@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:38216 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422786AbXDXR2J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Apr 2007 13:28:09 -0400
Content-Disposition: inline
In-Reply-To: <20070424172713.GB21882@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

pw@osc.edu wrote on Tue, 24 Apr 2007 13:27 -0400:
> Changes required to make bsg patches work on top of bidi patches.  Adds
> capability to bsg to handle bidirectional commands and extended CDBs.

Oops.  This is 2/2.  Apply the "compile with bidi" one first.

		-- Pete
