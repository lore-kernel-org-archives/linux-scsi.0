From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 1/3] SCSI Userspace Target: scsi-ml changes
Date: Mon, 06 Feb 2006 16:14:41 -0600
Message-ID: <1139264082.3022.53.camel@mulgrave.il.steeleye.com>
References: <1138157885.11692.32.camel@max>
	 <1139164228.3017.14.camel@mulgrave.il.steeleye.com>
	 <20060206113356T.fujita.tomonori@lab.ntt.co.jp>
	 <43E78D68.7010301@cs.wisc.edu>
	 <1139248965.3022.11.camel@mulgrave.il.steeleye.com>
	 <43E793F2.6070703@cs.wisc.edu>
	 <1139250832.3022.26.camel@mulgrave.il.steeleye.com>
	 <43E79948.2090004@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:11670 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932271AbWBFWPH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 17:15:07 -0500
In-Reply-To: <43E79948.2090004@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

On Mon, 2006-02-06 at 12:45 -0600, Mike Christie wrote:
> Yeah it looks that will work for the work struct and scsi_host pointer 
> we were adding. Thanks. Will convert our code.

OK ... don't rely on it just yet ... workqueue.c isn't exactly my code
to modify ...


James


