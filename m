From: David Miller <davem@davemloft.net>
Subject: Re: MPT fusion SAS target numbering...
Date: Sun, 03 May 2009 12:44:11 -0700 (PDT)
Message-ID: <20090503.124411.159206386.davem@davemloft.net>
References: <1241307038.3639.73.camel@mulgrave.int.hansenpartnership.com>
	<20090502.170912.263716496.davem@davemloft.net>
	<660360F4F2570145BD872F298951B17A80F01F54@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39770
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756002AbZECToR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2009 15:44:17 -0400
In-Reply-To: <660360F4F2570145BD872F298951B17A80F01F54@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, tayfun.kocaoglu@sun.com, Greg.Onufer@sun.com

From: "Moore, Eric" <Eric.Moore@lsi.com>
Date: Sat, 2 May 2009 22:20:28 -0600

> I debated this problem with you and Christoph back when we designed
> the sas transport layer several years back.  You guys said that
> persistency will be handled by udev (device ids or path), and the
> debate ended with that.  If you want to change this now, that would
> be great (making many customers much happier).

Please do this.

The current situation is absolutely awful :-(
