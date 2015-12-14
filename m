From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [PATCH 1/7] iscsi-target: Use a variable initialisation in
 iscsi_set_default_param() directly
Date: Mon, 14 Dec 2015 12:38:28 +0100
Message-ID: <566EAA34.5000301@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <566C2F7B.6030704@users.sourceforge.net>
 <566C308A.6000109@users.sourceforge.net> <20151212194939.GQ5284@mwanda>
 <20151214084114.GB31151@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:49945 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206AbbLNLik (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Dec 2015 06:38:40 -0500
In-Reply-To: <20151214084114.GB31151@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>

> @@ -127,9 +127,8 @@ static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_list *para
>  		char *name, char *value, u8 phase, u8 scope, u8 sender,
>  		u16 type_range, u8 use)
>  {
> -	struct iscsi_param *param = NULL;
> +	struct iscsi_param *param;
>  
> 	param = kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
>  	if (!param) {
>  		pr_err("Unable to allocate memory for parameter.\n");
> 
> 
> This way it would be _far_ more readable.

I guess that there are some opinions available for this implementation detail.


> IMHO one should have a 1 action per line of code style

How often do you care for such style issues?


> and only assign values in at declaration time if really necessary.

Which is or might become the official Linux coding style recommendation
for this aspect?


> But what is the benefit from this? Is it fixing a (hypothetical) bug?

I find the shown null pointer initialisation just needless.

Regards,
Markus

