From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] sym53c8xx PPR negotiation fix
Date: 29 Oct 2003 11:11:28 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067447490.1829.30.camel@mulgrave>
References: <1067447221.3112.336.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:5124 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262098AbTJ2RLm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 12:11:42 -0500
In-Reply-To: <1067447221.3112.336.camel@compaq.xsintricity.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Wed, 2003-10-29 at 11:07, Doug Ledford wrote:
> I haven't checked if this is applicable to 2.6 as well.  James?

Well, the sym driver doesn't exist anymore in 2.6...however sym_2 had a
similar issue.  Matthew Wilcox has already fixed it though, I think.

James


