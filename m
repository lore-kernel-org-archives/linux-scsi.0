From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: advansys problems
Date: 01 Jul 2003 20:05:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1057086331.18956.23.camel@dhcp22.swansea.linux.org.uk>
References: <200306301731.02662.nehal@canada.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:14483
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S263818AbTGASyF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jul 2003 14:54:05 -0400
In-Reply-To: <200306301731.02662.nehal@canada.com>
List-Id: linux-scsi@vger.kernel.org
To: nehal@canada.com
Cc: linux-scsi@vger.kernel.org

On Maw, 2003-07-01 at 01:31, nehal@canada.com wrote:
> i get this error with 2.4.21-ac4
> 
> advansys: advansys_reset: board 0: SCSI bus reset started...
> advansys: advansys_reset: board 0: SCSI bus reset successful...
> scsi: device set offline - not ready or command retry failed after bus reset: 
> host 0 channel 0 id 0 lun 0
> 
> then it displays the 2 'advansys_reset' messages again and freezes...
> i never used to get any of these problems or messages in 
> kernel version 2.4.21, 
> 
> is this bug known already?

Can you try a kernel with ACPI disabled as a first guess (-ac and base
are the same for the advansys driver)

