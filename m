From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 4/12]  qla2xxx: Update license.
Date: Fri, 14 Oct 2005 23:37:40 +1000
Message-ID: <434FB4A4.2040904@torque.net>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>	 <20051013231614.27191.9897.sendpatchset@plap.qlogic.com> <1129275031.2873.3.camel@laptopd505.fenrus.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:63662 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1750747AbVJNNg6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 09:36:58 -0400
In-Reply-To: <1129275031.2873.3.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Arjan van de Ven wrote:
> On Thu, 2005-10-13 at 16:16 -0700, Andrew Vasquez wrote:
> 
>>Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> 
> 
>>+++ b/Documentation/scsi/LICENSE.qla2xxx
>>@@ -0,0 +1,59 @@
>>+Copyright (c)  2003-2005 QLogic Corporation
>>+QLogic Linux Fibre Channel HBA Driver
>>+
>>+This program includes a device driver for Linux 2.6 that may be
>>+distributed with QLogic hardware specific firmware binary file.
>>+You may modify and redistribute the device driver code under the
>>+GNU General Public License as published by the Free Software
>>+Foundation (version 2 or a later version) and/or under the
>>+following terms, as applicable:
>>+
>>+	1. Redistribution of source code must retain the above
>>+	   copyright notice, this list of conditions and the
>>+	   following disclaimer.
>>+
>>+	2. Redistribution in binary form must reproduce the above
>>+	   copyright notice, this list of conditions and the
>>+	   following disclaimer in the documentation and/or other
>>+	   materials provided with the distribution.
>>+
>>+	3. The name of QLogic Corporation may not be used to
>>+	   endorse or promote products derived from this software
>>+	   without specific prior written permission.
>>+
> 
> 
> 
> as one of the people who made significant changes to the qlogic driver I
> object to this license change, especially because it was a one sided
> change without consultation beforehand.

Arjan,
Apart from not being consulted beforehand, what precisely
is objectionable in the above?

> James: please do not apply this.
> 
> Andrew: you can't do this. You just CANNOT change the license of code
> you don't own fully without consent of ALL contributors.

Often wondered about that. Someone sends me a bug fix,
I accept it, credit them and then at some later stage
want to broaden the license on that code from GPL to
BSD (say). Do I need the bug fixer's permission?

Doug Gilbert
