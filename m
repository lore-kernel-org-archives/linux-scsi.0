From: boutcher@cs.umn.edu (Dave C Boutcher)
Subject: [PATCH 2/2] ibmvscsi: handle inactive SCSI target during probe
Date: Thu, 6 Jul 2006 22:11:51 -0500
Message-ID: <17581.53495.411412.39342@hound.rchland.ibm.com>
References: <17581.52781.675644.492909@hound.rchland.ibm.com>
	<17581.53313.139646.861713@hound.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.34.202]:54420 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S1751162AbWGGDOo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jul 2006 23:14:44 -0400
Received: from localhost (localhost [127.0.0.1])
	by augustus.cs.umn.edu (Postfix) with ESMTP id C00A35C537
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jul 2006 22:14:43 -0500 (CDT)
Received: from mail.cs.umn.edu ([127.0.0.1])
 by localhost (mail.cs.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id 04020-02-3 for <linux-scsi@vger.kernel.org>;
 Thu,  6 Jul 2006 22:14:42 -0500 (CDT)
Received: from tera.cs.umn.edu (tera.cs.umn.edu [128.101.35.163])
	by mail.cs.umn.edu (Postfix) with ESMTP id 7FB8C5C532
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jul 2006 22:14:42 -0500 (CDT)
In-Reply-To: <17581.53313.139646.861713@hound.rchland.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 6 Jul 2006 22:08:49 -0500, boutcher@cs.umn.edu (Dave C Boutcher) said:
> 
> Without this patch we register an interrupt with request_irq,
> but then return a bad return code from the module probe.

Sigh...

Signed-off-by: Dave Boutcher <sleddog@us.ibm.com>
