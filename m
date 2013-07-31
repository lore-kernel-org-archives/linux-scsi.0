From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup / early userspace transition
Date: Tue, 30 Jul 2013 23:10:36 -0400
Message-ID: <yq14nbbifv7.fsf@sermon.lab.mkp.net>
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
	<87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
	<87fvuxdqes.fsf@spindle.srvr.nix> <51F708A4.9090207@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50143 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab3GaDLA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jul 2013 23:11:00 -0400
In-Reply-To: <51F708A4.9090207@interlog.com> (Douglas Gilbert's message of
	"Mon, 29 Jul 2013 20:28:20 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Nix <nix@esperi.org.uk>, Bernd Schubert <bernd.schubert@fastmail.fm>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, nick.cheng@areca.com.tw, stable@vger.kernel.org

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> I just examined a more recent Areca SAS RAID controller and would
Doug> describe it as the SCSI device from hell. One solution to this
Doug> problem is to modify the arcmsr driver so it returns a more
Doug> consistent set of lies to the management SCSI commands that Martin
Doug> is asking about.

Yeah. This is quite the challenge given that the product id is
user-specified and product revision hardcoded. I can match on "Areca" in
the vendor id and that's about it :(

My current approach is to tweak the driver so that I can set
skip_vpd_pages for the ATA models. Under the assumption that the SAS
controllers actually feature the ATA Information VPD...

-- 
Martin K. Petersen	Oracle Linux Engineering
