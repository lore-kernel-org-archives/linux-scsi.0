From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 13/15] bfa: Introduced initiator based lun masking feature.
Date: Thu, 18 Aug 2011 18:11:54 -0500
Message-ID: <4E4D9C3A.1030903@cs.wisc.edu>
References: <1311206643-13045-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48791 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab1HRXIL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Aug 2011 19:08:11 -0400
In-Reply-To: <1311206643-13045-1-git-send-email-kgudipat@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kgudipat@brocade.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, huangj@brocade.com, adapter_linux_open_src_team@brocade.com

On 07/20/2011 07:04 PM, kgudipat@brocade.com wrote:
> From: Krishna Gudipati <kgudipat@brocade.com>
> 
> Change details:
> 	- Added support to enable initiator based lun masking.
> 	- Initiator based Lun masking works similar to zoning where
> 	  initiator port is allowed to see only those LUNs which are
> 	  configured to be seen.

We do not really want drivers doing lun masking do we? This patch seems
wrong on so many levels. Drivers should not be doing lun masking. It
should go into something like scsi-ml and be a common interface. If it
was implemented in drivers it seems like it should take advantage of the
slave callouts instead of faking sense.
