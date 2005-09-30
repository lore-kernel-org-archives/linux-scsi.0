From: James.Smart@Emulex.Com
Subject: RE: I request inclusion of SAS Transport Layer and AIC-94xx intothe kernel
Date: Fri, 30 Sep 2005 18:25:22 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F46E1@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:56463 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030490AbVI3WZj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Sep 2005 18:25:39 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.patterson@hp.com, luben_tuikov@adaptec.com
Cc: mark_salyzyn@adaptec.com, dougg@torque.net, torvalds@osdl.org, ltuikov@yahoo.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> > 
> > > buffers limited to page size, etc.
> > 
> > "You have an attribute larger than 4k?  What is it?"
> 
> Not sure at the moment, can I guarantee this for the future?

FC wants to do NameServer queries, allow generic CT requests, etc.
Payload sizes are arbitrary, and can certainly be larger than 4k.
Also - payload must occur in both directions.

-- james 
