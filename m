From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Thu, 26 May 2005 08:59:01 -0400
Message-ID: <1117112341.4967.14.camel@mulgrave>
References: <20050516085832.GA9558@gmail.com>
	 <20050517071307.GA4794@in.ibm.com> <20050517002908.005a9ba7.akpm@osdl.org>
	 <20050517083436.GB4794@in.ibm.com>  <20050526003930.71bb14fb.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:39313 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261396AbVEZM72 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2005 08:59:28 -0400
In-Reply-To: <20050526003930.71bb14fb.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: dino@in.ibm.com, gregoire.favre@gmail.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-05-26 at 00:39 -0700, Andrew Morton wrote:
> Gents, can you please confirm that 2.6.12-rc5 is working OK now?

Everything apart from the Sony DVD domain validation issue should be
solved.  I'm still trying to find a clue to the last one from the traces
(it also doesn't look aic specific ... I think the DVD would do the same
thing on a different controller).

James


