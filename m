From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Add attributes to FC transport
Date: 10 Sep 2004 12:29:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094833803.2553.40.camel@mulgrave>
References: <8D43EFD7CCBDB24980134BE078C227E70881386D@xcm.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:54761 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267578AbUIJQaH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2004 12:30:07 -0400
In-Reply-To: <8D43EFD7CCBDB24980134BE078C227E70881386D@xcm.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Rajan, Mukesh" <Mukesh.Rajan@Emulex.Com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'andrew.vasquez@qlogic.com'" <andrew.vasquez@qlogic.com>, "'brking@us.ibm.com'" <brking@us.ibm.com>

On Fri, 2004-08-06 at 16:46, Rajan, Mukesh wrote:
> We would like to export certain HBA attributes such as Port Type, Port
> Speed etc via sysfs in the lpfc driver. These attributes are more
> representative of the transport layer and it will benefit from including
> them as generic FC transport attributes. Also the patch corrects the
> illegal values of node_name, port_name and port_id to zero, which are the
> accepted NULL values as per the FC-GS-4 standards.
> 
> Please apply.

Your mailer has mangled the attached patch to add line breaks when the
lines are > 80 chars long.  Could you send an unmangled patch, please?

James


