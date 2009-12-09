From: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.32-rc8
Date: Wed, 09 Dec 2009 10:17:53 -0800
Message-ID: <1260382673.1309.1.camel@jbarnes-desktop.localdomain>
References: <1259620194.11762.137.camel@mulgrave.site>
	 <20091201141035.2c0165df@jbarnes-piketon>
	 <1260295225.4147.25.camel@mulgrave.site>  <200912082107.03585.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outbound-mail-302.bluehost.com ([67.222.53.9]:42771 "HELO
	outbound-mail-302.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756554AbZLIS3l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2009 13:29:41 -0500
In-Reply-To: <200912082107.03585.rjw@sisk.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: James Bottomley <James.Bottomley@suse.de>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-pci@vger.kernel.org

On Tue, 2009-12-08 at 21:07 +0100, Rafael J. Wysocki wrote:
> I guess at the moment it's better to apply the workaround first and then
> remove it when the correct interface is ready.
> 
> I really wouldn't like to hurry with reworking pci_save_state(), because that
> has a potential of infroducing some new nasty bugs if not done with care.
> 
> Jesse, what's your opinion?

Yeah, that's fine.  I won't have time to hack anything together for a
week or two either, and I don't want to hold up a valid fix.

Jesse

