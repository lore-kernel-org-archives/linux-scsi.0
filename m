From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [iscsi 2/2] iscsi-probe.c
Date: Wed, 24 Sep 2003 10:11:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030924101152.A17901@beaverton.ibm.com>
References: <20030924144817.A16189@infradead.org> <018b01c382b7$b7f81220$8f074d0a@apac.cisco.com> <20030924174046.A20362@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:2024 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261535AbTIXRNR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 13:13:17 -0400
Content-Disposition: inline
In-Reply-To: <20030924174046.A20362@infradead.org>; from hch@infradead.org on Wed, Sep 24, 2003 at 05:40:46PM +0100
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: "Sachin Mhatre (smhatre)" <smhatre@cisco.com>, 'Jeff Garzik' <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

On Wed, Sep 24, 2003 at 05:40:46PM +0100, 'Christoph Hellwig' wrote:

> > We read/write into the "/proc/scsi/scsi" file for
> > configuration/deconfiguration of iSCSI devices.
> 
> I see.  And that's exactly wrong.  Take a look at the usb-storage or sbp2
> drivers on how to handle it.

They could use scsi_scan_host_selected(host, chan, target, SCAN_WILD_CARD,
0) or a scan target function, though their current lun scanning looks odd.

What was wrong with exporting scsi_scan_host_selected?

We don't have a scsi_remove_target().

-- Patrick Mansfield
