From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux Virtual SCSI HBAs and Virtual disks
Date: Thu, 25 Jan 2007 23:01:12 +0100
Message-ID: <45B928A8.7050907@s5r6.in-berlin.de>
References: <1e157f74d8578f24c762571c1016aab3@aboo.org> <b43c8fc9882e65d397a6465e6cb7c998@aboo.org> <45B4EAAC.5000008@s5r6.in-berlin.de> <45B60993.9070508@aboo.org> <45B6D18A.8000607@torque.net> <45B9241D.5040807@aboo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:39630 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030619AbXAYWBa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jan 2007 17:01:30 -0500
In-Reply-To: <45B9241D.5040807@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aboo Valappil <aboo@aboo.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Aboo Valappil wrote:
> What would i do if the SCSI target does not return any sense code? I
> make some thing up or just return no-sense?

I guess it depends on whether the in-kernel part of your software stack
actually knows enough details to generate correct sense codes.

> In the new version, I made up  SK="Illegal request", ASC="Invalid
> Opcode" if I do not receive any sense from target. But I think I
> should return  no sense, ie SK=0, ASC=0, ASCQ=0.

I think ASC/ASCQ = 0/0 = "no additional sense information" would indeed
be correct on such occasions.
-- 
Stefan Richter
-=====-=-=== ---= ==--=
http://arcgraph.de/sr/
