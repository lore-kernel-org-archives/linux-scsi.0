From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 3/4] aic94xx: cleanup after a discovery error
Date: Fri, 10 Nov 2006 16:42:13 -0800
Message-ID: <45551C65.6000000@us.ibm.com>
References: <1163102636.6521.19.camel@localhost.localdomain>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:32142 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S1946859AbWKKAmP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Nov 2006 19:42:15 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kAB0gFil021712
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 19:42:15 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kAB0gESS346524
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 17:42:14 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kAB0gEek011857
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 17:42:14 -0700
In-Reply-To: <1163102636.6521.19.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Alexis Bruemmer wrote:

> One question that remains with this patch is whether or not 
> sas_get_port_device should be moved into sas_discover_{sas,expander} to
> ensure that the rphy struct is allocated and freed-in-error in the same
> function 

It looks as though we could move the parts of sas_get_port_device() that
deal with rphy allocation/initialization into the
sas_discover_{sata,sas,expander} functions?  I don't know for sure; I
could be missing some subtlety that requires the sas_rphy creation to be
in sas_get_port_device.

--D
