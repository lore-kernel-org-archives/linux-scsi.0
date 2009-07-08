From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: SCST Target driver support for Emulex lpfc FC/FCoE adapters
Date: Wed, 08 Jul 2009 21:53:24 +0400
Message-ID: <4A54DD14.8050100@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:59498 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbZGHRxP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2009 13:53:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>
Cc: James Smart <James.Smart@Emulex.Com>

Hi All,

I'm glad to announce that SCST target driver support for Emulex lpfc 
FC/FCoE adapters has been created and linked to the SCST project. Thanks 
to the Emulex team for putting this together.

The driver allows for lpfc adapters to be placed in initiator and/or 
target mode. Those in initiator mode will continue to function with the 
SCSI subsystem as usual. A lpfc_scst helper module is then loaded that 
binds that target mode adapters with the SCST subsystem for use as FCP 
targets. NPIV is also supported, allowing virtual ports to be created 
with individual SCST target instances bound to them.

The lpfc SCST driver kit is part of the lpfcxxxx SourceForge project 
located at https://sourceforge.net/projects/lpfcxxxx. You can find its 
README and HOWTO in http://lpfcxxxx.sourceforge.net/README and 
http://lpfcxxxx.sourceforge.net/HOWTO.lpfc correspondingly.

SCST page of the Emulex lpfc target driver located at 
http://scst.sourceforge.net/target_emulex.html.

Vlad
