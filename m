From: Ravi Shankar <ravi.v.shankar@oracle.com>
Subject: Re: mpt2sas: /sysfs sas_address entries do not show individual port
 sas addresses.
Date: Thu, 18 Aug 2011 10:57:51 -0700
Message-ID: <4E4D529F.9090908@oracle.com>
References: <4E4B9B04.10302@mpstor.com> <4E4BDFD7.3060109@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:31425 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1HRR6C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Aug 2011 13:58:02 -0400
Received: from rtcsinet22.oracle.com (rtcsinet22.oracle.com [66.248.204.30])
	by rcsinet15.oracle.com (Switch-3.4.4/Switch-3.4.4) with ESMTP id p7IHvxUN019902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2011 17:58:01 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by rtcsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id p7IHvvSX022311
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2011 17:57:58 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id p7IHvq0w015316
	for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2011 12:57:52 -0500
In-Reply-To: <4E4BDFD7.3060109@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


>
>
> Do you know a reason why it is not preferably for every
> phy on a SAS HBA to respond with the same SAS address?
>
>
> As a practical matter a SAS HBA needs a single SAS address,
> preferably printed on the board or its box. Then if you
> manage to wipe its SAS address (e.g. by erasing its flash
> to move from IR to IT firmware) then you know which SAS
> address to re-instate :-)
>
HBA SAS phy could have same SAS address when they are directly connected.
however when connected to expanders, each logical port/phy need unique SAS
address.

