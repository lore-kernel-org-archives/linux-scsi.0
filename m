From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch 0/8] Change SG_ALL to mean "any size"
Date: Thu, 17 Jan 2008 18:53:01 +0100
Message-ID: <478F95FD.4060803@s5r6.in-berlin.de>
References: <478F8435.5000907@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:54648 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYAQRyM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 12:54:12 -0500
In-Reply-To: <478F8435.5000907@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> Those that meant SG_ALL == 255:
> 
>   [PATCH 1/8] firewire: ieee1394: Move away from SG_ALL

They simply mean SG_ALL == something, as long as it isn't unreasonably
small or large.
-- 
Stefan Richter
-=====-==--- ---= =---=
http://arcgraph.de/sr/
