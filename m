From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: Re: [patch 18/24] megaraid: Dell CERC ATA100/4ch support
Date: Wed, 27 Sep 2006 12:39:15 +0200
Message-ID: <451A54D3.5090302@tis.icnet.pl>
References: <890BF3111FB9484E9526987D912B261932E347@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d1.icnet.pl ([212.160.220.21]:3759 "EHLO d1.icnet.pl")
	by vger.kernel.org with ESMTP id S965485AbWI0Kjf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Sep 2006 06:39:35 -0400
In-Reply-To: <890BF3111FB9484E9526987D912B261932E347@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: akpm@osdl.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Ju, Seokmann wrote:
> Hi,
> On Tuesday, August 15, 2006 2:10 AM, Janusz Krzysztofik wrote:
>> Add CERC subsystem ids to the old megaraid driver.  Tested, works.
> NACK - This addition will create PCI ID overlapping with megaraid_{mbox,mm} module under driver/scsi/megaraid.
> Since 2.6.16, we have removed some IDs in the megaraid module under driver/scsi to address ID overlappijng issue.
> Please switch to megaraid_{mbox,mm} module for the controller support. megaraid module under driver/scsi is dedicated to very old products.
> 
> Seokmann

Hi,

Dell CECR ATA100/4ch does not work with the new megaraid_mbox driver for 
me. The adapter is recognized, but it does not show any virtual nor 
physical drives. I have no skills to correct the problem. Furthermore, I 
have found some comments on this hardware no longer supported by Dell, 
RedHat, etc.

Will you accept a patch that limits PCI IDs with VID=101E, DID=1960 and 
SSVID=1028 in the new driver to exactly three models specified in its 
source file comments and, on the other hand, adds PCI ID of Dell CERC 
ATA100/4ch to the old driver?

Janusz

