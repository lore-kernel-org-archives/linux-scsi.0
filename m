From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 00/11] qla4xxx: Update for scsi-misc
Date: Wed, 15 Feb 2012 01:00:29 -0600
Message-ID: <4F3B580D.7030709@cs.wisc.edu>
References: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55408 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab2BOHAS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Feb 2012 02:00:18 -0500
In-Reply-To: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com

On 02/13/2012 07:00 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
> 
> Please apply the following patches to scsi-misc for inclusion in mainline.
> 
> Lalit Chandivade (3):
>       qla4xxx: Fix un-necessary delay on invalid DDB
>       qla4xxx: Fix verify boot idx correctly
>       qla4xxx: Remove un-necessary print statment
> 
> Manish Rangankar (1):
>       qla4xxx: Modified debug log messages for boot info.
> 
> Vikas Chaudhary (7):
>       qla4xxx: Remove unused code
>       qla4xxx: Proper detection of firmware abort error code for ISP82xx
>       scsi_transport_iscsi: added support for host event
>       qla4xxx: added support for host event
>       iscsi_transport: Added Ping support
>       qla4xxx: added ping support
>       qla4xxx: Update driver version to 5.02.00-k14
> 


Looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
