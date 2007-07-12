From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] qla4xxx: Fix underrun/overrun conditions
Date: Thu, 12 Jul 2007 13:47:43 -0500
Message-ID: <4696774F.7090407@cs.wisc.edu>
References: <1181156124.5728.4.camel@q-iscsi-upstream.site> <1184010276.18914.4.camel@q-iscsi-upstream.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38060 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756925AbXGLSr4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jul 2007 14:47:56 -0400
In-Reply-To: <1184010276.18914.4.camel@q-iscsi-upstream.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: linux-scsi@vger.kernel.org, David Wagner <david.wagner@qlogic.com>

David C Somayajulu wrote:
> On Wed, 2007-06-06 at 11:55 -0700, David C Somayajulu wrote:
>> This patch fixes the code handling underrun and overrun conditions.
> Fix coding style as per Mike Christie's advice.
> 
> Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>
> 

You missed a space, but I do not think people care much about that. The 
patch looks ok from a technical standpoint compared to what other 
drivers are doing.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
