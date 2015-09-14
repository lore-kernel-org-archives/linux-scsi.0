From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/29] cxlflash: Miscellaneous bug fixes and corrections
Date: Mon, 14 Sep 2015 15:12:29 -0500
Message-ID: <8867AAC7-E67D-48B6-93DD-454B96F5979A@linux.vnet.ibm.com>
References: <1442006012-46803-1-git-send-email-mrochs@linux.vnet.ibm.com> <1442188796-sup-7396@delenn.ozlabs.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:49512 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbbINUMY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2015 16:12:24 -0400
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 14 Sep 2015 14:12:24 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 3B0C919D803F
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2015 14:03:14 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8EKBUJ411272552
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2015 13:11:30 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8EKCJ1T021824
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2015 14:12:20 -0600
In-Reply-To: <1442188796-sup-7396@delenn.ozlabs.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, "James.Bottomley" <James.Bottomley@HansenPartnership.com>, nab <nab@linux-iscsi.org>, brking <brking@linux.vnet.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, "andrew.donnellan" <andrew.donnellan@au1.ibm.com>, mikey <mikey@neuling.org>

> On Sep 13, 2015, at 8:12 PM, Ian Munsie <imunsie@au1.ibm.com> wrote:
> 
> Hi Matt & Manoj,
> 
> Just a general comment about this series - I'd like to see more detailed
> commit messages for almost all these patches. Of course James is the
> scsi maintainer and it's up to him whether to take these as is or not,
> but generally when you write a commit message for a bug fix you want to
> explain:
> 
> - What problem can occur, possibly including an example
> - Why it occurs
> - How this patch addresses it
> 
> You don't necessarily need to go overboard because at some point people
> can just read the code, but some of these patches don't have any detail
> beyond a single subject line, which is too little.
> 
> Speaking of the subject line - if the patch is fixing a bug there should
> be some indication of that in the subject (it should probably include
> the word "fix" somewhere). If the subject just states what you are
> changing then it's not immediately obvious that it is a bug fix.

This is a reasonable request. Will incorporate your suggestions
and send out in a v2 series. Thanks for the examples of what you
would like to see.


-matt

