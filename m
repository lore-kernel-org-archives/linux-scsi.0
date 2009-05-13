From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 0/7] lpfc 8.3.1 : Update lpfc to revision 8.3.1
Date: Wed, 13 May 2009 12:22:51 -0700
Message-ID: <4A0B1E0B.40108@oracle.com>
References: <1239058022.2344.19.camel@ogier>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:48841 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbZEMTUw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2009 15:20:52 -0400
In-Reply-To: <1239058022.2344.19.camel@ogier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>

James Smart wrote:
> Update lpfc driver to revision 8.3.1
> 
> Includes the following changes :
> - A set of 5 patches to update kdoc headers. These were posted earlier
>    but have not been picked up yet.
> - A set of miscellaneous fixes/changes, all small in nature. Includes
>    Null pointer fixes, sparse fixes, and some feature updates.
>  - Update driver version to 8.3.0
> 
> -- james s

James (Bottomley),

Can we get this patchset merged for 2.6.30?

It fixes http://bugzilla.kernel.org/show_bug.cgi?id=13242
which I am also running into quite often.

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
