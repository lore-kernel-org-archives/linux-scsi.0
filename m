From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] BusLogic: add error handling, fix queuecommand, docs.
Date: Thu, 2 Oct 2003 13:59:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031002135952.6c5c35d2.rddunlap@osdl.org>
References: <20031001122316.6f33af9b.rddunlap@osdl.org>
	<20031001214818.GB1045@beaverton.ibm.com>
	<20031001144324.60097c36.rddunlap@osdl.org>
	<20031001173750.68a2c6a5.rddunlap@osdl.org>
	<1065126868.3839.453.camel@compaq.xsintricity.com>
	<20031002134834.76911a14.rddunlap@osdl.org>
	<1065128677.3839.456.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:52927 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263492AbTJBVIS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2003 17:08:18 -0400
In-Reply-To: <1065128677.3839.456.camel@compaq.xsintricity.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: andmike@us.ibm.com, linux-scsi@vger.kernel.org

On Thu, 02 Oct 2003 17:04:37 -0400 Doug Ledford <dledford@redhat.com> wrote:

| On Thu, 2003-10-02 at 16:48, Randy.Dunlap wrote:
| > Doug, thanks for looking and correcting me.
| > I'll fix those & repost it.
| 
| No problem.
| 
| > Meanwhile, the driver has already been tested & used succesfully
| > by one user:
| >   <http://bugme.osdl.org/show_bug.cgi?id=1086>
| 
| Those are rarely used error paths.  Just because a user hasn't hit it
| doesn't mean it wouldn't cause problems if they did ;-)

Yes, I understand that.

--
~Randy
