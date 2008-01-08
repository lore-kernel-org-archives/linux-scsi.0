From: Hannes Reinecke <hare@novell.com>
Subject: Buggy Firewire bridge 'Prolific PL3507'
Date: Tue, 08 Jan 2008 14:43:34 +0100
Message-ID: <47837E06.5080406@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbYAHNng (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jan 2008 08:43:36 -0500
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 175742F91B
	for <linux-scsi@vger.kernel.org>; Tue,  8 Jan 2008 14:43:35 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi all,

I have here a buggy firewire bridge (Prolific PL3507) which requires that each 'INQUIRY' command is followed by a 'READ CAPACITY' command. Otherwise any read will return invalid data (the payload is preceded by 36 empty bytes).

How to fix this? Sure one could add a hack to sbp2.c to always issue a READ CAPACITY after INQUIRY, but this somehow feels wrong ...

Cheers,

Hannes
