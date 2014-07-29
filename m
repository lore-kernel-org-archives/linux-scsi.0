From: Juergen Gross <jgross@suse.com>
Subject: Re: [Xen-devel] [PATCH V2 1/4] Add XEN pvSCSI protocol description
Date: Tue, 29 Jul 2014 09:39:54 +0200
Message-ID: <53D74FCA.1080007@suse.com>
References: <1406288253-13293-1-git-send-email-jgross@suse.com>	<1406288253-13293-2-git-send-email-jgross@suse.com> <53D65E09.5020901@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbaG2Hj5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2014 03:39:57 -0400
In-Reply-To: <53D65E09.5020901@citrix.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com, target-devel@vger.kernel.org, konrad.wilk@oracle.com

On 07/28/2014 04:28 PM, David Vrabel wrote:
> On 25/07/14 12:37, jgross@suse.com wrote:
>> From: Juergen Gross <jgross@suse.com>
>>
>> Add the definition of pvSCSI protocol used between the pvSCSI frontend in a
>> XEN domU and the pvSCSI backend in a XEN driver domain (usually Dom0).
>>
>> This header was originally provided by Fujitsu for XEN based on Linux 2.6.18.
>> Changes are:
>> - added comment
>> - adapt to Linux style guide
>> - add support for larger SG-lists by putting them in an own granted page
>> - remove stale definitions
>
> This is a protocol extension and needs to be reviewed separately, and
> the Xen header needs updating as well.

Sure. The review can start right now. Updating the Xen header will be
done as soon as the drivers are accepted in Linux.

> The documentation for this protocol is rather lacking.  In particular it
> is missing the connection states.

Regarding documentation: I'll add some.

Regarding the connection states: I'd rather move the description in
blkif.h to xenbus.h than duplicating it in vscsiif.h. What do you think?


Juergen
