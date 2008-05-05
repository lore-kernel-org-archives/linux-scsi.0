From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: LSI SAS 1068e RAID driver for Debian won't load
Date: Mon, 5 May 2008 08:53:23 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E822901047BE5@NAMAIL2.ad.lsil.com>
References: <16992119.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:62596 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbYEEOxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2008 10:53:34 -0400
Content-class: urn:content-classes:message
In-Reply-To: <16992119.post@talk.nabble.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: AlphaGJohn <jc-mailinglist@alphagconsulting.com>, linux-scsi@vger.kernel.org

On Wednesday, April 30, 2008 3:40 PM,  AlphaGJohn wrote:
> lspci reports the controller as:
> 02:00.0 SCSI storage controller: LSI Logic / Symbios Logic 
> Unknown device
> 0059 (rev 04)
> 

0x59 device id is owned  by the megaraid driver called megasr, meaning
software raid.    You will need to contact the megaraid team to obtain
the proper drivers.  This controller is not support by mptsas driver, as
the bios/firmware that ships with this 0x59 controller will corrupt you
disk with metadata as it will by default its creating a raid volume.
The mptsas driver works with the ids you noted before, 50, 54, 56, 58,
and 62. 

Eric
