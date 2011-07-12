From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/2] be2iscsi: Adding shutdown routing
Date: Tue, 12 Jul 2011 15:57:09 -0500
Message-ID: <4E1CB525.2070404@cs.wisc.edu>
References: <9f89710f-b612-4066-94a2-b44656c7d069@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35852 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab1GLUyo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2011 16:54:44 -0400
In-Reply-To: <9f89710f-b612-4066-94a2-b44656c7d069@exht1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jayamohan.kallickal@Emulex.Com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com

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
