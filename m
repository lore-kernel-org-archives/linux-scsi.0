From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH] iscsi: avoid oops when destroying unbound connection
Date: Mon, 30 Oct 2006 14:17:52 -0500
Message-ID: <20061030191752.GA13857@osc.edu>
References: <20061030012912.GA12233@osc.edu> <45463E29.2070204@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:12752 "EHLO quasar.osc.edu")
	by vger.kernel.org with ESMTP id S1161401AbWJ3TRx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Oct 2006 14:17:53 -0500
Content-Disposition: inline
In-Reply-To: <45463E29.2070204@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

michaelc@cs.wisc.edu wrote on Mon, 30 Oct 2006 12:02 -0600:
> Thanks for the patch. We actually already fixed this by just removing
> that list. It was not being used for what it was originally intended and
> was getting in the way.
> 
> The fix should be in 2.6.19-rc4 when it comes out.

That's even better.  For future reference, where is the SCSI or
iSCSI development tree?  I had guessed it might be jejb's
scsi-misc-2.6 git, but that still has conn->item, as does your
linux-2.6-iscsi git.  If I can check for fixes before sending off a
patch, it will save us all some time.

		-- Pete
