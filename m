From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/6] iscsi bug fixes for 2.6.31-rc
Date: Wed, 15 Jul 2009 13:58:25 -0500
Message-ID: <4A5E26D1.4070209@cs.wisc.edu>
References: <4A5BFB45.50004@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48933 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209AbZGOS62 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2009 14:58:28 -0400
Received: from [10.15.94.199] ([65.122.67.201])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id n6FIwQax003183
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2009 13:58:27 -0500
In-Reply-To: <4A5BFB45.50004@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:
> The following patches were made over scsi-fix-fixes. They fix bugs in 
> libiscsi and qla4xxx. Please apply for the next 2.6.31-rc if they are ok.

James,

These patches have a bug.

I am going to fix up and resend.
