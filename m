From: Andrew Morton <akpm@osdl.org>
Subject: Re: [GIT PATCH] final SCSI fixes for 2.6.15-rc5
Date: Wed, 14 Dec 2005 16:50:03 -0800
Message-ID: <20051214165003.29e0904c.akpm@osdl.org>
References: <1134604909.11150.2.camel@mulgrave>
	<43A0B6CA.9090200@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:32648 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965107AbVLOAsg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2005 19:48:36 -0500
In-Reply-To: <43A0B6CA.9090200@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James.Bottomley@SteelEye.com, torvalds@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Michael Reed <mdr@sgi.com> wrote:
>
> If possible, a comment on my previous email which identified two
> other issues with SCSI would be appreciated before 2.6.15 goes
> final.

Just so nobody else has to go hunting, here:

	http://marc.theaimsgroup.com/?l=linux-scsi&m=113458339109319&w=2
