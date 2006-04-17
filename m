From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [RFC] FC Transport : Async Events via netlink interface
Date: Mon, 17 Apr 2006 16:46:08 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70080E17@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:4043 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751360AbWDQWqX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Apr 2006 18:46:23 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Monday, April 17, 2006 2:44 PM, James Smart wrote:  

> 
> [netdev folks copied to review the use of the netlink interface]
> 
> This patch adds HBAAPI async event support to the FC transport.
> 
> Events are pushed to userspace via Netlink. This is per the previous
> RFC comments given in :

It would be nice to extend this to scsi_transport_sas, and start
work to addressing sas management, e.g. csmi/sdi. But I did get copied
on an email from Bob Nixon of Emulex saying something about extending
the 
HBA API defined for Fibre Channel/FCP to include consistent management 
of SAS HBAs as well. Do you know anything about this James?

Eric Moore
