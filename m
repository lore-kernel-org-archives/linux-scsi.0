From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Host Channel TargetId LUN enumeration and scope
Date: Mon, 16 Feb 2009 15:15:50 +0100
Message-ID: <49997516.3040708@s5r6.in-berlin.de>
References: <677131e90902160009r7b1b43f3t53b11c032be28b72@mail.gmail.com>	 <677131e90902160011u5613c7fibf29bb16f68a86a7@mail.gmail.com> <677131e90902160015g2e63a29byb020a98bf7369686@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56343 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbZBPOP6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Feb 2009 09:15:58 -0500
In-Reply-To: <677131e90902160015g2e63a29byb020a98bf7369686@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dheeraj Sangamkar <dheerajrs@gmail.com>
Cc: linux-scsi@vger.kernel.org

Dheeraj Sangamkar wrote:
> I would like to know how each of the Host Channel TargetId and LUN are
> enumerated and assigned to each SCSI device.

Randomly.

The [h:c:i:l] tuple is a Linux SCSI core internal artifact and is *not*
to be confused with initiator port identifier, target port identifier,
and logical unit identifier (a.k.a. LUN).

[...]
> How are LUN Ids enumerated? Does the order in which the response
> REPORT_LUN command gives LUNs, determine the LUN ID assignment for a
> SCSI disk discovered on a remote target on an array connected via FC?

The SCSI core does not care about LUNs and does not even pass LUNs
through from transport layer to application clients.

You can obtain LUNs from transport-layer specific sysfs attributes, but
not from the Linux SCSI core layer.
-- 
Stefan Richter
-=====-==--= --=- =----
http://arcgraph.de/sr/
