From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Fw: 2.6.0-test9 kernel oops
Date: 24 Nov 2003 09:23:44 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069687425.1900.9.camel@mulgrave>
References: <20031123231037.44115c6f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:29190 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263766AbTKXPXw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 10:23:52 -0500
In-Reply-To: <20031123231037.44115c6f.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Tomas Kostrian <kostrian@deepblue.sk>

On Mon, 2003-11-24 at 01:10, Andrew Morton wrote:
> Can anyone else with an aic7xxx reproduce (and hence fix) this?
> /proc/scsi/aic7xxx/0 works happily on my test box.

Actually (since I managed to dig out an x86 aic7xxx based machine), I've
tried this and not seen the problem...it could be because I've been
testing out with the two SCSI refcount fixes as well...I'll try
stripping them back.

James


