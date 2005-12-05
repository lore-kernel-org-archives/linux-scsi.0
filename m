From: Graham Knap <graham.knap@rogers.com>
Subject: Re: Bug#338089: New aic7xxx driver fails spectacularly on 2940UW
Date: Sun, 4 Dec 2005 20:49:35 -0500 (EST)
Message-ID: <20051205014935.99703.qmail@web88002.mail.re2.yahoo.com>
References: <1133214118.3325.59.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web88002.mail.re2.yahoo.com ([206.190.37.189]:8377 "HELO
	web88002.mail.re2.yahoo.com") by vger.kernel.org with SMTP
	id S1751094AbVLEBtg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Dec 2005 20:49:36 -0500
In-Reply-To: <1133214118.3325.59.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Horms <horms@debian.org>, Doug Ledford <dledford@redhat.com>, 338089@bugs.debian.org, linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> OK, try the attached.  If it works out, I'll soak it in -mm for
> a while and then try to put it in as a bug fix for 2.6.15.

<snip>

This works for me. The DV write tests are skipped and the system boots
cleanly. The boot messages are the same as when we ifdef'd out the "get
echo buffer" call.

-- graham
