From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 15278] New: lockdep warning for iscsi in 2.6.33-rc6
Date: Thu, 11 Feb 2010 16:50:11 -0600
Message-ID: <4B7489A3.3070804@cs.wisc.edu>
References: <bug-15278-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56630 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825Ab0BKWvI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Feb 2010 17:51:08 -0500
In-Reply-To: <bug-15278-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, open-iscsi <open-iscsi@googlegroups.com>

On 02/11/2010 02:05 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> This entry is being used for tracking a regression from 2.6.32.  Please don't
> close it until the problem is fixed in the mainline.
>

Hey Tao,

So did you narrow this down to being a regression starting in 2.6.32?
