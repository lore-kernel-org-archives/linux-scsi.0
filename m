From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ipr: RESEND: fix PCI permanent error handler
Date: Wed, 20 May 2009 16:16:53 -0500
Message-ID: <1242854213.2881.82.camel@localhost.localdomain>
References: <1240246790.7458.112.camel@zeppelin.austin.ibm.com>
	 <1240258429.3315.60.camel@mulgrave.int.hansenpartnership.com>
	 <49ECD89D.3000005@linux.vnet.ibm.com>
	 <1240846712.3387.18.camel@mulgrave.int.hansenpartnership.com>
	 <1241444469.8515.21.camel@zeppelin.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42392 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755509AbZETVQu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 May 2009 17:16:50 -0400
In-Reply-To: <1241444469.8515.21.camel@zeppelin.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kleber S. Souza" <klebers@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2009-05-04 at 10:41 -0300, Kleber S. Souza wrote:
> O@@ -7003,6 +7003,7 @@ static void ipr_pci_perm_failure(struct pci_dev
> *pdev)

OK, so the tabs are fixed, but you mailer still broke this line.  I
fixed it up, but you really need to find a working email tool for next
time.

James


