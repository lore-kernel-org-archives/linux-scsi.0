From: =?iso-8859-1?Q?Hor=E1k_Daniel?= <horak@sitmp.cz>
Subject: RE: [PATCH 2.6.13-rc6] fix copying stack memory in cpqfcTScontrol.c::cpqfcTSPutLinkQue()
Date: Wed, 17 Aug 2005 19:11:59 +0200
Message-ID: <66EFFC1A2B0A424E87D68EC10B1F458D65980F@EXCH2.plzen-city.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fred2.plzen-city.cz ([195.113.166.14]:37296 "EHLO
	fred2.plzen-city.cz") by vger.kernel.org with ESMTP
	id S1751173AbVHQRMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2005 13:12:10 -0400
Received: from exch2.plzen-city.cz ([192.168.4.51])
	by fred2.plzen-city.cz (8.11.7/8.11.7/Wim) with ESMTP id j7HHBxw29951
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2005 19:11:59 +0200
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> First of all: since the request for a working version of this 
> driver is not
> longer there at the moment I'll only send out what I 
> currently have to get it
> into list archives. Merging this would be fine to decrease 
> the amount of bugs
> in this (and the size of it). I removed everyone but 
> linux-scsi from recipient
> list because of this. Removing the stack error is rather 
> simple now, but I 
> don't do it for now to make sure noone uses this beast until 
> it's fixed.

I really would like to see this driver working in 2.6, because it is the
only way how to connect old Compaq FC arrays. In one or two weeks I will
have a test hardware available, so I can help at least with testing the
driver.


			Dan
