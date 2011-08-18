From: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: FireWire/SBP2 Target mode
Date: Thu, 18 Aug 2011 18:19:20 +0200
Message-ID: <4E4D3B88.30003@ladisch.de>
References: <4E4BD560.4010806@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38760 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755228Ab1HRQTW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Aug 2011 12:19:22 -0400
In-Reply-To: <4E4BD560.4010806@bootc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Boot <bootc@bootc.net>, target-devel@vger.kernel.org
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>

Chris Boot wrote:
> Now that we have a nice SCSI target framework in the kernel, and drivers
> either in-tree or being worked on for iSCSI, FC, FCoE, SAS and iSER, I
> was wondering about the possibility of adding FireWire to that list.

As far as I can tell from briefly looking at the framework, this would
require both a fabric module (which is nicely abstracted) and a new
protocol (which doesn't seem to be).

Is there any documentation of how to add a new LIO protocol?

And what is the difference between a protocol and a fabric?


Regards,
Clemens
