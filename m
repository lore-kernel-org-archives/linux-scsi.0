From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: [LSF]: fc_rport attributes to further populate HBAAPIv2
Date: Fri, 1 Apr 2011 12:57:01 -0700
Message-ID: <C9BB62DD.17720%giridhar.malavali@qlogic.com>
References: <20110401171838.GD20986@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:7145 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab1DAT5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2011 15:57:07 -0400
In-Reply-To: <20110401171838.GD20986@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "lsf@lists.linux-foundation.org" <lsf@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

James,

I would also like to discuss the following topic.

The patches were submitted to linux-scsi earlier which basically includes
fc_rport attributes to FC transport.
Here are the links to previous submission

http://marc.info/?l=linux-scsi&m=128828294426031&w=2
http://marc.info/?l=linux-scsi&m=128828255825328&w=2
http://marc.info/?l=linux-scsi&m=128828263025468&w=2


>From review comments from community (Christof S and James Smart), it is
felt that a common implementation either in transport or block layer would
be better to avoid all LLD implementing this. In an effort the BSG
interface is extended to send in-kernel BSG commands to query name server
and get the required information to populate.

Here are the links for the review comments received

http://marc.info/?l=linux-scsi&m=128834912816011&w=2
http://marc.info/?l=linux-scsi&m=128838095128776&w=2
http://marc.info/?l=linux-scsi&m=128871208700376&w=2


I would like to discuss to tap more idea from community for any better
approach. If not, to continue with the present approach.

Thanks,
Giridhar Malavali





This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

