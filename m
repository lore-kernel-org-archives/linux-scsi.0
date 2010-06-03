From: Richard Scobie <richard@sauce.co.nz>
Subject: RE: mptsas hangs caused by ATA pass-through explained
Date: Fri, 04 Jun 2010 08:07:36 +1200
Message-ID: <4C080B88.205@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.sauce.co.nz ([210.48.49.72]:33277 "EHLO smtp.sauce.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab0FCUOS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jun 2010 16:14:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>

Kashyap wrote:

I have also verified this patch + also done code review with our 
developers including Eric Moore. Please consider this patch as an ACKed 
patch and schedule it for next upstream release.

----------------------

Hi,

In comment #20 of this bug entry:

https://bugzilla.kernel.org/show_bug.cgi?id=14831

you state:

"Patch for setting dma boundary is mere avoiding condition which is 
causing this
issue. LSI Gen-1 controller does not have 512byte dma boundary limitation. I
have started internal chat with our Firmware engineer. I will update you
findings as and when some imp stuffs are found."

Is this still the case, or is the patch the final fix?

Also, comment #25 in the same thread notes a significant negative write 
performance impact.

Are you seeing this?

I have several machines in production I would like to update, but not if 
there is a better solution to this on it's way.

Regards,

Richard
