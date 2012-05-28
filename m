From: =?ISO-8859-1?Q?Kai_P=F6ritz?= <kai@poeritz.de>
Subject: -Werror in CONFIG_SCSI_LPFC
Date: Mon, 28 May 2012 17:33:49 +0200
Message-ID: <4FC39ADD.4080003@poeritz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from belug.de ([192.109.21.30]:38536 "EHLO belug.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab2E1QlH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 May 2012 12:41:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by belug.de (Postfix) with ESMTP id D5C0B5A7096E
	for <linux-scsi@vger.kernel.org>; Mon, 28 May 2012 18:33:51 +0200 (CEST)
Received: from belug.de ([127.0.0.1])
	by localhost (belug.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zEGQOz1ZmnPO for <linux-scsi@vger.kernel.org>;
	Mon, 28 May 2012 18:33:45 +0200 (CEST)
Received: from [192.168.4.243] (i59F77589.versanet.de [89.247.117.137])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by belug.de (Postfix) with ESMTPSA id A75E65A6ADB3
	for <linux-scsi@vger.kernel.org>; Mon, 28 May 2012 18:33:45 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I don't know if this is the right email to write this to. But I feel 
there is still a -Werror in the makefile of this scsi module.

CONFIG_SCSI_LPFC

Thanks

Kai
