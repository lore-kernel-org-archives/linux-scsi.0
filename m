From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 14/24] Implement scsi_opcode_sa_name
Date: Fri, 3 Oct 2014 01:26:20 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCBDD9@G4W3202.americas.hpqcorp.net>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
 <1412144580-72880-15-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:1491 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaJCB2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 21:28:34 -0400
In-Reply-To: <1412144580-72880-15-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
...
> +struct sa_name_list {
> +	int cmd;
> +	const struct value_name_pair *arr;
> +	int arr_sz;
> +};

cmd usually refers to a whole structure and is usually 
a pointer variable.  grep searches will be easier if 
you name that field "opcode".

> +
> +static struct sa_name_list sa_names_arr[] = {
> +	{VARIABLE_LENGTH_CMD, variable_length_arr, VARIABLE_LENGTH_SZ},
> +	{MAINTENANCE_IN, maint_in_arr, MAINT_IN_SZ},
> +	{MAINTENANCE_OUT, maint_out_arr, MAINT_OUT_SZ},
> +	{PERSISTENT_RESERVE_IN, pr_in_arr, PR_IN_SZ},
> +	{PERSISTENT_RESERVE_OUT, pr_out_arr, PR_OUT_SZ},
> +	{SERVICE_ACTION_IN_12, serv_in12_arr, SERV_IN12_SZ},
> +	{SERVICE_ACTION_OUT_12, serv_out12_arr, SERV_OUT12_SZ},
> +	{SERVICE_ACTION_BIDIRECTIONAL, serv_bidi_arr, SERV_BIDI_SZ},
> +	{SERVICE_ACTION_IN_16, serv_in16_arr, SERV_IN16_SZ},
> +	{SERVICE_ACTION_OUT_16, serv_out16_arr, SERV_OUT16_SZ},
> +	{THIRD_PARTY_COPY_IN, tpc_in_arr, TPC_IN_SZ},
> +	{THIRD_PARTY_COPY_OUT, tpc_out_arr, TPC_OUT_SZ},
> +	{0, NULL, 0},
> +};
> +
> +static bool scsi_opcode_sa_name(int cmd, int service_action,
> +				const char **sa_name)
...


