From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 11804] New: iscsi: LRO plus iSCSI causes panic
Date: Thu, 6 Nov 2008 16:29:13 -0800
Message-ID: <20081106162913.29d7d695.akpm@linux-foundation.org>
References: <bug-11804-10286@http.bugzilla.kernel.org/>
	<20081021172721.027d9e1c.akpm@linux-foundation.org>
	<F169D4F5E1F1974DBFAFABF47F60C10A0E9DB65A@orsmsx507.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533AbYKGA3z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 19:29:55 -0500
In-Reply-To: <F169D4F5E1F1974DBFAFABF47F60C10A0E9DB65A@orsmsx507.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, bugme-daemon@bugzilla.kernel.org

On Thu, 6 Nov 2008 16:08:08 -0800
"Brandeburg, Jesse" <jesse.brandeburg@intel.com> wrote:

> Andrew Morton wrote:
> > (switched to email.  Please respond via emailed reply-to-all, not via
> > the bugzilla web interface).
> 
> This panic is still unaddressed.

It looks like we own it :(

>  Can I provide more information?
> 
> >> http://bugzilla.kernel.org/show_bug.cgi?id=11804

I guess it would be useful to use addr2line or gdb or whatever to work
out exactly which statement is faulting, which pointer contains the
garbage value, etc.
