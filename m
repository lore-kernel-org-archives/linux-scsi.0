From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: LSI Logic 1068E and SATA port replicators (Sil3726)
Date: Fri, 04 Dec 2009 11:48:46 +0100
Message-ID: <4B18E90E.3090401@interlog.com>
References: <4B18C83C.6060105@diskware.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:47088 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbZLDKso (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Dec 2009 05:48:44 -0500
In-Reply-To: <4B18C83C.6060105@diskware.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Scholl <ms@diskware.net>
Cc: linux-scsi@vger.kernel.org

Martin,
There is mention of SATA port selectors in the SAS spec
(optional functionality in a SAS expander I think) but
no mention of SATA port multipliers.
The reason might be that a SAS expander already includes the
functionality of a SATA port multiplier.

The "ATA architectural notes" in Annex J of sas2r16.pdf found
at www.t10.org might help.

Doug Gilbert


Martin Scholl wrote:
> Hello all,
> 
> 
> [disclaimer: what follows is probably a really stupid idea after all.]
> 
> We would like to use a LSI SAS 1068E board with Sil3726 SATA port
> replicators. This obviously "fails" in that only 1 disk out of the 5
> connected is actually visible.
> 
> I found, if SATA drivers are to support a port multiplier, they inhert
> from sata_pmp_port_ops. Is an analog infrastructure available for the
> sas-based HBAs to support SATA port multipliers? (BTW is such a setup
> actually supported form a protocol point of view?)
> 
> I'm not a regular kernel hacker, so I cannot really help you in getting
> quality sata mpm support (if possible after all) into the sas drivers.
> What I can definitely offer is my time and will to test the driver
> modifications you would send me.
> 
> 
> 
> Martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

