From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: bidi support: FC transport layer...
Date: Thu, 10 Jul 2008 11:14:43 -0500
Message-ID: <48763573.7070006@cs.wisc.edu>
References: <E11DE615-512A-45C0-9308-036BDA225E9D@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46470 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbYGJQOz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2008 12:14:55 -0400
In-Reply-To: <E11DE615-512A-45C0-9308-036BDA225E9D@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>

Seokmann Ju wrote:
> Hi,
> 
> With starting to implement FC-CT/ELS support on the qla2xxx module, I 
> would like to get some idea about the bidi-bidirectional.
> As I understand that the bidi is packet transporting infra-structure, I 
> think it could be good candidate for the FC specific FC-CT/ELS packet 
> delivery in between the application and the individual devices given 
> topology.

I think you might also want to look at bsg or really wanted to see bsg 
along with how to support bidi commands? You would want to look at 
block/bsg.c for the bsg driver. And see 
drivers/scsi/scsi_transport_sas.c's sas_bsg_initialize and its 
sas_non_host_smp_request functions for examples of how to send bsg to a 
transport class, and from a class to a class object like a rport 
(replace fc rport for a sas phy though).
