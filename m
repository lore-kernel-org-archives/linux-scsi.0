From: Tim Small <tim@seoss.co.uk>
Subject: Re: [smartmontools-support] Apparent MPT ata pass-through bug SAS1068
 and SAS1068E - WAS SMART causes disks to go offline on an LSI SAS1068 controller
 - Dell SAS 5/iR
Date: Thu, 29 Oct 2009 08:59:32 +0000
Message-ID: <4AE95974.9090809@seoss.co.uk>
References: <20090914142939.GE14072@boogie.lpds.sztaki.hu>	<4AE72E40.2000903@seoss.co.uk> <4AE8448C.6070709@seoss.co.uk>	<0D1E8821739E724A86F4D16902CE275C1C93A02A34@inbmail01.lsi.com>	<4AE877D3.4040300@seoss.co.uk> <4AE8B35D.2070609@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.allsecurenet.com ([63.246.152.102]:46090 "EHLO
	relay1.allsecurenet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbZJ2I7u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2009 04:59:50 -0400
In-Reply-To: <4AE8B35D.2070609@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Gabor Gombas <gombasg@sztaki.hu>, "smartmontools-support@lists.sourceforge.net" <smartmontools-support@lists.sourceforge.net>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Linux-PowerEdge@dell.com" <Linux-PowerEdge@dell.com>

Douglas Gilbert wrote:
> Now it is annoying, distracting and wasteful to log the sense
> data in this particular situation. Perhaps the SCSI mid level
> error reporting should filter out that particular combination:
>    Sense key: RECOVERED ERROR
>    Additional sense: ATA PASS THROUGH INFORMATION AVAILABLE (0x0,0x1d)
>
> References: sat-r09.pdf sat2r09.pdf
>   

Would this best be implemented as a patch to scsi_print_sense_hdr(...) /
scsi_cmd_print_sense_hdr(...) in drivers/scsi/constants.c?  Sorry - I've
never touched any of the scsi code, but I can probably look into
drafting a patch tomorrow?

Thanks,

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.  
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

