From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Creating a subdirectory under fc_host statistics using fc_function_template
Date: Sun, 04 Jan 2009 11:17:41 -0600
Message-ID: <4960EF35.2090502@cs.wisc.edu>
References: <ddedcbc75baf.493faa75@usc.edu> <494A86DE.7020908@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50451 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429AbZADRRx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jan 2009 12:17:53 -0500
In-Reply-To: <494A86DE.7020908@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, Krishna Gudipati <gudipati@usc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James Smart wrote:
> James,
> 
> What Krishna describes, is a need to add driver-specific attributes (and 
> optionally a directory of attributes) to a class-level object. I 
> attempted patches of a similar form when I was originally doing the 
> fc_rports, which were rejected.
> 
> I believe the position is that we do not allow driver-specific things on 
> the class objects, and drivers are limited in scope to only adding 
> individual attributes to the scsi_host via the attribute list in the 
> scsi_host_template.
> 
> I'd like to re-propose the patches to add driver-specific data to the FC 
> class objects. Do you believe there's a change in heart to accepting 
> this functionality before I start the work to create them ?
> 
> For example, I know that Emulex would have liked to add driver-specific 
> state data to the rports.  And Krishna's proposal is another request.
> 

We are having the same problem for iscsi. For qla4xxx and cxgb3i and 
bnx2i, we would like to add driver specific attrs to the iscsi 
session/connection which are like FC's rport struct.

I was hoping if at least the classes provide an API to add driver 
specific attrs similar to how scsi-ml does, then it would be ok?
