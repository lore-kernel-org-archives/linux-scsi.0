From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Return of PENDING status to SCSI driver
Date: Fri, 12 Jun 2009 19:26:21 +0200
Message-ID: <4A328FBD.4080602@s5r6.in-berlin.de>
References: <3e7aae30906120229p3bbeb7f0jd07c5f1e823a456a@mail.gmail.com>	 <4A323CE8.7010207@garzik.org> <3e7aae30906120554u189d4abdye0f40cd2ddc12f58@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:35456 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbZFLR1M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2009 13:27:12 -0400
In-Reply-To: <3e7aae30906120554u189d4abdye0f40cd2ddc12f58@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ramya Desai <ramya.desai@gmail.com>
Cc: linux-scsi@vger.kernel.org

Ramya Desai wrote:
> I used can_queue  to change the queue depth to 5, but I am not getting
> the next command until I finish (Done) the first command. I wanted the
> second command to come to my driver, even before first command
> finishes.

Did you also set cmd_per_lun?
-- 
Stefan Richter
-=====-==--= -==- -==--
http://arcgraph.de/sr/
