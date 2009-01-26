From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 12544] New: megaraid kernel oops during smartd poll
Date: Mon, 26 Jan 2009 13:15:59 -0800
Message-ID: <20090126131559.0a59ef1b.akpm@linux-foundation.org>
References: <bug-12544-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558AbZAZVQE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2009 16:16:04 -0500
In-Reply-To: <bug-12544-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, dimetrios@gmail.com

On Mon, 26 Jan 2009 12:54:29 -0800 (PST)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=12544
> 
>            Summary: megaraid kernel oops during smartd poll

googling for `megaraid_queue_command oops' elicits a long and sorry tale.

Seems that this bug (or a very similar one) was also present in
2.6.9-42.0.2.ELsmp (http://lkml.org/lkml/2007/3/8/467) so perhaps it
isn't a regression.


