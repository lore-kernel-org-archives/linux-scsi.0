From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] BusLogic: add error handling, fix queuecommand, docs.
Date: Thu, 02 Oct 2003 17:04:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065128677.3839.456.camel@compaq.xsintricity.com>
References: <20031001122316.6f33af9b.rddunlap@osdl.org>
	 <20031001214818.GB1045@beaverton.ibm.com>
	 <20031001144324.60097c36.rddunlap@osdl.org>
	 <20031001173750.68a2c6a5.rddunlap@osdl.org>
	 <1065126868.3839.453.camel@compaq.xsintricity.com>
	 <20031002134834.76911a14.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pix-525-pool.redhat.com ([66.187.233.200]:30266 "EHLO
	lacrosse.corp.redhat.com") by vger.kernel.org with ESMTP
	id S263482AbTJBVGT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2003 17:06:19 -0400
In-Reply-To: <20031002134834.76911a14.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: andmike@us.ibm.com, linux-scsi@vger.kernel.org

On Thu, 2003-10-02 at 16:48, Randy.Dunlap wrote:
> Doug, thanks for looking and correcting me.
> I'll fix those & repost it.

No problem.

> Meanwhile, the driver has already been tested & used succesfully
> by one user:
>   <http://bugme.osdl.org/show_bug.cgi?id=1086>

Those are rarely used error paths.  Just because a user hasn't hit it
doesn't mean it wouldn't cause problems if they did ;-)

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


