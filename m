From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: MPTSAS Driver and scatter gather lists
Date: Tue, 4 Dec 2007 12:58:04 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70BA6CA6@NAMAIL4.ad.lsil.com>
References: <47557600.5040902@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:58987 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbXLDT6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2007 14:58:12 -0500
Content-class: urn:content-classes:message
In-Reply-To: <47557600.5040902@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Pratt <slpratt@austin.ibm.com>, linux-scsi@vger.kernel.org

On Tuesday, December 04, 2007 8:45 AM,  Steven Pratt wrote:
> 
> Also, is there any reason we can't increase sg_tablesize for mptsas?
> 

The default 128, set in Kconfig (look at FUSION_MAX_SGE).    It only set
to 40 when that is not defined.  What is in your kernel .config, e.g
look for CONFIG_FUSION_MAX_SGE.

Eric
