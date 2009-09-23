From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] be2iscsi: Moving to pci_pools v3
Date: Wed, 23 Sep 2009 12:04:15 -0500
Message-ID: <4ABA550F.1000504@cs.wisc.edu>
References: <20090922025217.GA19987@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58585 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbZIWREU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Sep 2009 13:04:20 -0400
In-Reply-To: <20090922025217.GA19987@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 09/21/2009 09:52 PM, Jayamohan Kallickal wrote:
>   This patch contains changes to use pci_pools for iscsi hdr
> instead of pci_alloc_consistent. Here we alloc and free to pool
> for every IO
>
> v3:
> - Remove cleanup loop in beiscsi_session_destroy
> - Fixup for allocation failure handling in beiscsi_alloc_pdu
> - Removed unused variable in beiscsi_session_destroy.
>
> Signed-off-by: Jayamohan Kallickal<jayamohank@serverengines.com>

Thanks for fixing those issues.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
