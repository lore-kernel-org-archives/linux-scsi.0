From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 02/11] qla4xxx: added IPv6 support.
Date: Wed, 07 Apr 2010 13:00:02 -0500
Message-ID: <4BBCC822.3050209@cs.wisc.edu>
References: <20100407172645.0434d49b@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39817 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab0DGRzt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Apr 2010 13:55:49 -0400
In-Reply-To: <20100407172645.0434d49b@mailhost.serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: "ravi.anand" <ravi.anand@qlogic.com>, James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, open-iscsi <open-iscsi@googlegroups.com>, Karen Xie <kxie@chelsio.com>

On 04/07/2010 12:26 PM, Jayamohan Kalickal wrote:
> Mike,
>
>     Yes, IPV6 works for be2iscsi. One of our guys had set it up and we were able to do login etc.
>
> You mentioned that be2iscsi handling is incorrect, can you let me know the details
>

Do

cat /sys/class/iscsi_host/hostX/ipaddress

You will not get anything, because you set the iscsi_transport template 
bit to export this setting, but you did not handle it in the get host 
param callout.
