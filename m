From: Foster_Brian@emc.com
Subject: RE: [ANNOUNCE]: A target driver for Marvell 88SE64xx(3G) and 88SE94xx(6G) SAS cards
Date: Tue, 9 Jun 2009 09:03:13 -0400
Message-ID: <D27CA15508148C428A25104ADEFAAC8103BB633B@CORPUSMX50C.corp.emc.com>
References: <49E4B6D5.9060007@vlnb.net> <D27CA15508148C428A25104ADEFAAC8103AC1E41@CORPUSMX50C.corp.emc.com> <4A2D2E8F.6090207@vlnb.net> <D27CA15508148C428A25104ADEFAAC8103BB6034@CORPUSMX50C.corp.emc.com> <5FF020A1CFFEEC49BD1E09530C4FF595714E369F@SC-VEXCH1.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:32779 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZFINgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2009 09:36:44 -0400
Content-class: urn:content-classes:message
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF595714E369F@SC-VEXCH1.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ayan@marvell.com, vst@vlnb.net
Cc: linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, James.Bottomley@HansenPartnership.com

> Brian,
> 	Please set unique SAS address for each SAS port of target
> controller, and make sure you do correct connection, you can get the
SAS
> address of attaching device from "attach sas address ".Then enable
target
> mode and add target LUN.
> 
> Regards
> Andy Yan
> 

Not quite sure I follow... Is this value read from HW at init time? Do
we have an interface available where I can explicitly set a SAS address
for the port? Thanks.

Brian
