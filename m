From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] SCSI: Use is_power_of_2() macro for simplicity.
Date: Wed, 07 Nov 2007 14:59:25 -0600
Message-ID: <4732272D.8070507@cs.wisc.edu>
References: <Pine.LNX.4.64.0711061019450.9041@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46359 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbXKGU7g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Nov 2007 15:59:36 -0500
In-Reply-To: <Pine.LNX.4.64.0711061019450.9041@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-scsi@vger.kernel.org

Robert P. J. Day wrote:
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---

Thanks for the iscsi bits. We have the libiscsi part from 
vignesh.babu@wipro.com queued for 2.6.25. And the iscsi_tcp parts you 
are patching over are broken and I am going to fix that for 2.6.25. We 
only support 1 r2t right now so we cannot hit the bug where if userspace 
negotiated X r2ts we have to use X r2ts we cannot round up.
