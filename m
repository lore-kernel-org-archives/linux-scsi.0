From: <Jayamohan.Kallickal@Emulex.Com>
Subject: RE: [PATCH 1/2] be2iscsi: Adding shutdown routing
Date: Tue, 12 Jul 2011 15:16:23 -0700
Message-ID: <50725EF61B96174EB1803401F1A2E37337F57CC1E3@EXMAIL.ad.emulex.com>
References: <9f89710f-b612-4066-94a2-b44656c7d069@exht1.ad.emulex.com>
 <4E1CB525.2070404@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht2.emulex.com ([138.239.113.184]:17189 "EHLO
	exht2.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755451Ab1GLWQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2011 18:16:47 -0400
In-Reply-To: <4E1CB525.2070404@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com

Will modify for new changelog, rename Rolf to Eike and remove the tags. 

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Tuesday, July 12, 2011 1:57 PM
To: Kallickal, Jayamohan
Cc: linux-scsi@vger.kernel.org; James.Bottomley@hansenpartnership.com
Subject: Re: [PATCH 1/2] be2iscsi: Adding shutdown routing

On 07/12/2011 12:12 PM, jayamohan.kallickal@Emulex.Com wrote:
> From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> 
>   This patch adds a  shutdown routine
> 
> Signed-off-by: Jayamohan Kallickal <jayamohan,kallickal@emulex.com>
> ---
>  drivers/scsi/be2iscsi/be_cmds.c |    2 +-
>  drivers/scsi/be2iscsi/be_main.c |   10 +
>  drivers/scsi/be2iscsi/be_main.h |    1 +

The iscsi/driver parts are ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

>  drivers/scsi/be2iscsi/tags      | 1588 +++++++++++++++++++++++++++++++++++++++

You do not need want this tags part in your patch. Maybe James can just
drop that part for you when/if he merges it.
