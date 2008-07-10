From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: bidi support: FC transport layer...
Date: Thu, 10 Jul 2008 11:13:54 -0700
Message-ID: <9C52C942-25A9-402D-861F-5625513E63A9@qlogic.com>
References: <E11DE615-512A-45C0-9308-036BDA225E9D@qlogic.com> <48763573.7070006@cs.wisc.edu>
Mime-Version: 1.0 (Apple Message framework v924)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:17782 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbYGJSN5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 14:13:57 -0400
In-Reply-To: <48763573.7070006@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>


On Jul 10, 2008, at 9:14 AM, Mike Christie wrote:

> Seokmann Ju wrote:
>> Hi,
>> With starting to implement FC-CT/ELS support on the qla2xxx module,  
>> I would like to get some idea about the bidi-bidirectional.
>> As I understand that the bidi is packet transporting infra- 
>> structure, I think it could be good candidate for the FC specific  
>> FC-CT/ELS packet delivery in between the application and the  
>> individual devices given topology.
>
> I think you might also want to look at bsg or really wanted to see  
> bsg along with how to support bidi commands? You would want to look  
> at block/bsg.c for the bsg driver. And see drivers/scsi/ 
> scsi_transport_sas.c's sas_bsg_initialize and its  
> sas_non_host_smp_request functions for examples of how to send bsg  
> to a transport class, and from a class to a class object like a  
> rport (replace fc rport for a sas phy though).
Thank you for the point, Mike.
I'm looking at the files as you pointed out.

Seokmann

