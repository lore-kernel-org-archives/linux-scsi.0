From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 1/2] scsi: TUR path is down after adapter gets reset in
 multipath configuration(scsi_error.c)
Date: Mon, 27 Oct 2014 19:07:28 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295933DF24@G9W0745.americas.hpqcorp.net>
References: <20141027180147.030955587@linux.vnet.ibm.com>
 <20141027180346.868651777@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:21039 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaJ0TI2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2014 15:08:28 -0400
In-Reply-To: <20141027180346.868651777@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "wenxiong@linux.vnet.ibm.com" <wenxiong@linux.vnet.ibm.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of wenxiong@linux.vnet.ibm.com
> Sent: Monday, 27 October, 2014 1:02 PM
> To: James.Bottomley@HansenPartnership.com
> Cc: hch@infradead.org; linux-scsi@vger.kernel.org;
> brking@linux.vnet.ibm.com
> Subject: [PATCH 1/2] scsi: TUR path is down after adapter gets reset
> in multipath configuration(scsi_error.c)
> 
> After an ipr adapter gets reset, all disk array devices require a
> start unit command to be issued to them before they will accept
> commands. So, with the SCSI EH change, we now end up in a scenario 
> with dual ipr adapters where the TUR getting issued from the health
> checker returns with a Not Ready response and since SCSI EH no
> longer triggers the Start Unit in this scenario, the path never
> recovers.
> 

This description doesn't make sense without reading the thread:
[dm-devel] [PATCH 1/1] multipath-tools: Change path checker for IBM IPR devices

Example: what is "the SCSI EH change"?

