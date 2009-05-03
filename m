From: David Miller <davem@davemloft.net>
Subject: Re: MPT fusion SAS target numbering...
Date: Sun, 03 May 2009 12:45:09 -0700 (PDT)
Message-ID: <20090503.124509.203910506.davem@davemloft.net>
References: <1241307038.3639.73.camel@mulgrave.int.hansenpartnership.com>
	<20090502.170912.263716496.davem@davemloft.net>
	<1241323833.3639.77.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39776
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642AbZECTpQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2009 15:45:16 -0400
In-Reply-To: <1241323833.3639.77.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: Eric.Moore@lsi.com, linux-scsi@vger.kernel.org, tayfun.kocaoglu@sun.com, Greg.Onufer@sun.com

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sat, 02 May 2009 23:10:33 -0500

> I Understand, that's why it's like the Fibre persistent bindings.  There
> are, unfortunately, good reasons why it can't be used as the target id,
> but if we just exported the id, udev can create a device node using it
> and you can mount via that device node in an across boot consistent
> manner ... will that do?

I see no reason why you wouldn't want to use known perfectly good
persistent SCSI target IDs computed by the card.

It doesn't make any sense, and it is inconsistent with how any
other piece of code in the world handles these values provided
by the card.
