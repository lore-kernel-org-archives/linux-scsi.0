From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] be2iscsi: Adding bsg Interface
Date: Wed, 04 Nov 2009 10:03:10 -0600
Message-ID: <4AF1A5BE.5060808@cs.wisc.edu>
References: <20091103231850.GA2468@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57384 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756926AbZKDQDM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Nov 2009 11:03:12 -0500
In-Reply-To: <20091103231850.GA2468@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org

Jayamohan Kallickal wrote:
>   This patch adds bsg Interface to the driver.
> 
> This patch is dependent on the patch from James Smart
> 
>    http://mail.spinics.net/lists/linux-scsi/msg40079.html
> 

Do you have userspace code that can use this now?
