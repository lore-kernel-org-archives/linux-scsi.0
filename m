From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: 02 Dec 2003 17:55:14 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070409314.1955.11.camel@mulgrave>
References: <03120118001300.08627@naveenb-lnx.cisco.com>
	<Pine.LNX.4.58.0312011655240.26106@serv>
	<03120217260300.01630@naveenb-lnx.cisco.com>
	<1070383028.2345.8.camel@mulgrave>
	<20031202174202.GA1960@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:7172 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264471AbTLBX4d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2003 18:56:33 -0500
In-Reply-To: <20031202174202.GA1960@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: naveenb@cisco.com, Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-12-02 at 11:42, Mike Anderson wrote:
> The user would need to generate another write request and the
> "guarantee" is up to the user (correct?)?

Well, not necessarily.  There are APIs to flush mmapped data which the
user can call.  However, the most likely thing (especially if the user
is careless---how many times do you code your apps to do fflush() for
instance?) is simply that automatic reaping will flush the page for you,
or failing that it will be flushed on process exit.

For mmapped file descriptors, there are other events which trigger
flushing, but I forget exactly what they are.

James


