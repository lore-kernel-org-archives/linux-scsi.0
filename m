From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 6/7] aacraid: unlock around kfree
Date: Wed, 03 Aug 2005 18:06:33 -0500
Message-ID: <1123110393.5019.53.camel@mulgrave>
References: <1123108776.24945.40.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:56251 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261236AbVHCXGm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2005 19:06:42 -0400
In-Reply-To: <1123108776.24945.40.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Wed, 2005-08-03 at 15:39 -0700, Mark Haverkamp wrote:
> kfree has the possibility of sleeping. It is generally considered poor
> manners to hold on to a lock with the possibility of a system call
> induced sleep.

Erm, this isn't true ... we'd have no end of driver issues if kfree
could block.

James


