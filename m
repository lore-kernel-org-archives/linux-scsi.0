From: Erez Zilber <erezz@voltaire.com>
Subject: Receiving a SCSI response after abort task was sent
Date: Sun, 02 Jul 2006 13:51:51 +0300
Message-ID: <44A7A547.6080709@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from taurus.voltaire.com ([193.47.165.240]:14208 "EHLO
	taurus.voltaire.com") by vger.kernel.org with ESMTP id S932289AbWGBKvx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Jul 2006 06:51:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have a question about aborting tasks: when an initiator sends "abort=20
task" to the target, it is possible that the target will send a SCSI=20
response for the same task before receiving the abort task (I guess tha=
t=20
the target won't send a task management response for the abort task).=20
What should the initiator do with the SCSI response? Is the host that=20
issued the abort task willing to receive a SCSI response for that task?=
=20
Is it willing to receive only a task management response for the abort =
task?

This message was also sent to ips mailing list.

Thanks
--=20

____________________________________________________________

Erez Zilber | 972-9-971-7689

Software Engineer, Storage Team

Voltaire =96 _The Grid Backbone_

__

www.voltaire.com <http://www.voltaire.com/>


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
