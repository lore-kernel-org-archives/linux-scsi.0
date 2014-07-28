From: David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH V2 1/4] Add XEN pvSCSI protocol description
Date: Mon, 28 Jul 2014 15:28:25 +0100
Message-ID: <53D65E09.5020901@citrix.com>
References: <1406288253-13293-1-git-send-email-jgross@suse.com> <1406288253-13293-2-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp02.citrix.com ([66.165.176.63]:32011 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaG1O2j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jul 2014 10:28:39 -0400
In-Reply-To: <1406288253-13293-2-git-send-email-jgross@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgross@suse.com, xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com, target-devel@vger.kernel.org, konrad.wilk@oracle.com

On 25/07/14 12:37, jgross@suse.com wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> Add the definition of pvSCSI protocol used between the pvSCSI frontend in a
> XEN domU and the pvSCSI backend in a XEN driver domain (usually Dom0).
> 
> This header was originally provided by Fujitsu for XEN based on Linux 2.6.18.
> Changes are:
> - added comment
> - adapt to Linux style guide
> - add support for larger SG-lists by putting them in an own granted page
> - remove stale definitions

This is a protocol extension and needs to be reviewed separately, and
the Xen header needs updating as well.

The documentation for this protocol is rather lacking.  In particular it
is missing the connection states.

David
