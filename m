From: Douglas Gilbert <dougg@torque.net>
Subject: scsi_debug driver with SAS support
Date: Tue, 30 Aug 2005 21:52:23 +1000
Message-ID: <43144877.8040801@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:20134 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751387AbVH3LwB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 07:52:01 -0400
Received: from localhost (localhost [127.0.0.1])
	by borg.st.net.au (Postfix) with ESMTP id E9AC3394674
	for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2005 21:52:30 +1000 (EST)
Received: from [192.168.48.80] (dsl-138.0.240.220.rns01-kent-syd.dsl.comindico.com.au [220.240.0.138])
	by borg.st.net.au (Postfix) with ESMTP id 3DBCE394626
	for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2005 21:52:30 +1000 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Many recent changes to drafts at www.t10.org are related
to Serial Attached SCSI (SAS). Changes to SCSI command sets
are mainly in the Vital Product Data (VPD) page and mode
page area and I have tried to track those in sg3_utils.
To test these new facilities I often add "target" code to
the scsi_debug driver. These may be useful to others working
in the same space. See http://www.torque.net/sg/sdebug26.html
The last entry in the Downloads table is a replacement for
the scsi_debug driver found in lk 2.6.13 (which is the second
last entry). A description of the additions follows the Downloads
table.

With these additions the scsi_debug driver can simulate one
or more dual ported SAS targets each with one or more LUs.
Artificial SAS addresses should obey most rules (apart from
being truly unique) across the device identification VPD page,
the SAS ports page and the SAS phy control and discover mode
(sub)page. Most recent betas of sg3_utils and sdparm can be
found in the news section of http://www.torque.net/sg


Doug Gilbert
