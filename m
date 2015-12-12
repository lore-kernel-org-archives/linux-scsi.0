From: walter harms <wharms@bfs.de>
Subject: Re: [PATCH 7/7] iscsi-target: Make two variable initialisations a
 bit more obvious in iscsi_check_valuelist_for_support()
Date: Sat, 12 Dec 2015 18:17:46 +0100
Message-ID: <566C56BA.7010903@bfs.de>
References: <566ABCD9.1060404@users.sourceforge.net> <566C2F7B.6030704@users.sourceforge.net> <566C3304.1090802@users.sourceforge.net>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx01-fr.bfs.de ([193.174.231.67]:57162 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbbLLRSA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Dec 2015 12:18:00 -0500
In-Reply-To: <566C3304.1090802@users.sourceforge.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>



Am 12.12.2015 15:45, schrieb SF Markus Elfring:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 12 Dec 2015 15:04:57 +0100
> 
> The variable "acceptor_values" and "proposer_values" were initialized
> by null pointers and immediately assigned values from input parameters
> by separate statements.
> Let us express the desired variable initialisations directly.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/target/iscsi/iscsi_target_parameters.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
> index 53e3345..fb6fd34 100644
> --- a/drivers/target/iscsi/iscsi_target_parameters.c
> +++ b/drivers/target/iscsi/iscsi_target_parameters.c
> @@ -921,10 +921,7 @@ static char *iscsi_check_valuelist_for_support(
>  	char *value)
>  {
>  	char *tmp1, *tmp2;
> -	char *acceptor_values = NULL, *proposer_values = NULL;
> -
> -	acceptor_values = param->value;
> -	proposer_values = value;
> +	char *acceptor_values = param->value, *proposer_values = value;
>  

I do not thing that this is a good idea,
i find the first version more readable
but you are right the NULL can be removed.

just my 2 cents,

re,
 wh



>  	do {
>  		if (!proposer_values)
