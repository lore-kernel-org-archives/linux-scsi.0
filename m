From: Jeremy Linton <jli@greshamstorage.com>
Subject: REQ_SPECIAL from scsi_execute_async()?
Date: Tue, 10 Jul 2007 14:21:26 -0500
Message-ID: <4693DC36.2010905@greshamstorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gatekeeper.greshamstorage.com ([216.143.252.225]:11880 "EHLO
	AUSEXCH1.greshamstorage.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758501AbXGJTky (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jul 2007 15:40:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi <linux-scsi@vger.kernel.org>

I was just looking at the REQ_SPECIAL handling and I was curious why 
REQ_SPECIAL isn't being set for commands being queued by 
scsi_execute_aysnc()? It is set for scsi_execute() commands.

Did someone overlook setting the flag or is this behavior intentional?




