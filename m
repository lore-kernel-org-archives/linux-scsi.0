From: Foster_Brian@emc.com
Subject: RE: [ANNOUNCE]: A target driver for Marvell 88SE64xx(3G) and 88SE94xx(6G) SAS cards
Date: Fri, 5 Jun 2009 14:10:09 -0400
Message-ID: <D27CA15508148C428A25104ADEFAAC8103AC1E41@CORPUSMX50C.corp.emc.com>
References: <49E4B6D5.9060007@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:46528 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbZFESL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2009 14:11:29 -0400
Content-class: urn:content-classes:message
In-Reply-To: <49E4B6D5.9060007@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vst@vlnb.net, linux-scsi@vger.kernel.org
Cc: scst-devel@lists.sourceforge.net, ayan@marvell.com, James.Bottomley@HansenPartnership.com

> Hi All,
> 
> I'm glad to announce that a target driver for Marvell 88SE64xx(3G) and
> 88SE94xx(6G) SAS cards has been just added in the SCST SVN repository.
A
> lot of thanks to Marvell and Andy Yan!
> 
> This driver allows to use a SAS controller based on Marvell 88SE64xx
or
> 88SE94xx chips as a SAN storage server (target). More info you can
find
> on the SCST page http://scst.sourceforge.net.
> 
> You can download the driver from SCST SVN by running a command:
> 
> $ svn co https://scst.svn.sourceforge.net/svnroot/scst
> 

Hi Vlad/Andy,

Is this target driver expected to work with 6320 cards as well? Using
this driver, I was able to discover a SATA drive connected to the 6320
in initiator mode. 

I connected the 6320 directly to a second 6320 on another machine, set
up a virtual LUN with SCST (added to the default group, etc.) and
enabled target mode, but I'm not seeing anything on the initiator side. 

Brian
