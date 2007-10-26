From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch 1/1] scsi: fix a few misleading comments in scsi.c
Date: Fri, 26 Oct 2007 17:05:00 +0200
Message-ID: <4722021C.4070606@s5r6.in-berlin.de>
References: <20071026134217.GA16709@beardog.cca.cpqcorp.net> <20071026143722.GS27248@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:55258 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbXJZPFC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Oct 2007 11:05:02 -0400
In-Reply-To: <20071026143722.GS27248@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

> On Fri, Oct 26, 2007 at 08:42:17AM -0500, scameron@beardog.cca.cpqcorp.net wrote:
>> - * needs to be release with scsi_host_put once you're done with it.
>> + * needs to be release with scsi_device_put once you're done with it.

Well, hopefully this fix goes finally in now. :-)
http://marc.info/?l=linux-scsi&m=114279682717770
-- 
Stefan Richter
-=====-=-=== =-=- ==-=-
http://arcgraph.de/sr/
