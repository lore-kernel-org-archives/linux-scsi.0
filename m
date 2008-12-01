From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 12119] New: iscsi repeatedly times out
Date: Sun, 30 Nov 2008 19:38:52 -0600
Message-ID: <4933402C.7000704@cs.wisc.edu>
References: <bug-12119-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35790 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbYLABjf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Nov 2008 20:39:35 -0500
In-Reply-To: <bug-12119-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

bugme-daemon@bugzilla.kernel.org wrote:
> Hardware Environment:diskless i386, swap on iscsi device
> Software Environment:open-iscsi v 6.2

What is the rest of this version string? With fedora run

rpm -q iscsi-initiator-utils
