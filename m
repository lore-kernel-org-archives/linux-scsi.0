From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 5659] Adaptec 29160 Ultra160 SCSI doesn't work with
	2.6.14 or +
Date: Tue, 18 Apr 2006 12:09:18 -0500
Message-ID: <1145380158.3216.20.camel@mulgrave.il.steeleye.com>
References: <BAY112-F188649A1A87780776413D9A0C70@phx.gbl>
	 <444420BA.2020709@yk.rim.or.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:56534 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932282AbWDRTDd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Apr 2006 15:03:33 -0400
In-Reply-To: <444420BA.2020709@yk.rim.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chiaki <ishikawa@yk.rim.or.jp>
Cc: Mun Hamlet <hamletmun@hotmail.com>, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org

On Tue, 2006-04-18 at 08:11 +0900, Chiaki wrote:
> Just for comparison purposes, I have an Adaptec 29160 in my PC and
> it runs just fine under 2.6.15.

The card and driver definitely work.  I also have one in my scsi test
rig.  The problem here seems to be a bad interaction with a DVD writer.
The only real difference between this and a standard SCSI disk (as far
as the driver sees it) is the untagged queuing, which is why I suggested
that first.

James


