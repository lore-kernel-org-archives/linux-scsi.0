From: "Zhao, Forrest" <forrest.zhao@intel.com>
Subject: RE: One question about SCSI device hotplug
Date: Wed, 2 Mar 2005 12:47:46 +0800
Message-ID: <8126E4F969BA254AB43EA03C59F44E8401850062@pdsmsx404>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from fmr20.intel.com ([134.134.136.19]:7849 "EHLO
	orsfmr005.jf.intel.com") by vger.kernel.org with ESMTP
	id S262168AbVCBEt1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2005 23:49:27 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>, James.Smart@Emulex.Com
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, "Caushik, Ramesh" <ramesh.caushik@intel.com>, sdake@mvista.com

< but the LLDD doesn't get an interrupt from the firmware on such
events).

So you mean that when SCSI device is surprise-removed, HBA will not
assert an interrupt to kernel? Even LLDD doesn't know the SCSI device is
removed?

Thanks,
Forrest
