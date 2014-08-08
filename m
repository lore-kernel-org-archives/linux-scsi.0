From: =?ISO-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Subject: Re: [Xen-devel] Add XEN pvSCSI support
Date: Fri, 08 Aug 2014 09:47:28 +0200
Message-ID: <53E48090.1090103@suse.com>
References: <1407483840-31436-1-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbaHHHrb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2014 03:47:31 -0400
In-Reply-To: <1407483840-31436-1-git-send-email-jgross@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, JBottomley@parallels.com, konrad.wilk@oracle.com, hch@infradead.org, david.vrabel@citrix.com, JBeulich@suse.com

Sorry, please ignore.

One wrong patch slipped in, while one is missing.

Will resend with correct patches.


Juergen

On 08/08/2014 09:43 AM, jgross@suse.com wrote:
> This series adds XEN pvSCSI support. With pvSCSI it is possible to use physical
> SCSI devices from a XEN domain.
>
> The support consists of a backend in the privileged Domain-0 doing the real
> I/O and a frontend in the unprivileged domU passing I/O-requests to the backend.
>
> The code is taken (and adapted) from the original pvSCSI implementation done
> for Linux 2.6 in 2008 by Fujitsu.
>
> [PATCH V2 1/4] Add XEN pvSCSI protocol description
> [PATCH V2 2/4] Introduce xen-scsifront module
> [PATCH V2 3/4] Introduce XEN scsiback module
> [PATCH V2 4/4] add xen pvscsi maintainer
>
> Changes in V4:
> - Re-add define for VSCSIIF_ACT_SCSI_SG_PRESET to vscsiif.h to indicate this
>    action value should not be used in future enhancements
>
> Changes in V3:
> - added some comments to the protocol header file
> - removed the CDB emulation from xen-scsiback, handled by core target
>    infrastructure
> - several changes in xen-scsifront after comments from Christoph Hellwig
>
> Changes in V2:
> - use core target infrastructure by backend instead of pure SCSI passthrough
> - add support for larger SG lists by putting them in grant page(s)
> - add command abort capability
>
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
>

