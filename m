From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 03/20] be2iscsi: Fixing the return type of functions
Date: Tue, 13 Jul 2010 02:29:13 -0500
Message-ID: <4C3C15C9.1030509@cs.wisc.edu>
References: <20100712175006.GA11396@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44072 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab0GMHZ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2010 03:25:57 -0400
In-Reply-To: <20100712175006.GA11396@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 07/12/2010 12:50 PM, Jayamohan Kallickal wrote:
> -
> -unsigned char mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
> +int mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
>   {
>   	struct be_ctrl_info *ctrl =&phba->ctrl;
>   	struct be_mcc_wrb *wrb = wrb_from_mccq(phba);
> @@ -144,7 +143,7 @@ unsigned char mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
>   	return status;
>   }
>

You forgot to change the caller of this function.
