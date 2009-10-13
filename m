From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] be2iscsi: Enabling MSIX and mcc_rings
Date: Mon, 12 Oct 2009 22:12:31 -0500
Message-ID: <4AD3F01F.8080703@cs.wisc.edu>
References: <20091013025211.GA7868@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42283 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbZJMDNP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2009 23:13:15 -0400
In-Reply-To: <20091013025211.GA7868@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org

Jayamohan Kallickal wrote:
>    This patch adds
> 
> 1) Turns on msix
> 2) mcc_ring support for sending FW commands
> 3) Support for Ring Mode of WRB Posting



>  
> +struct be_mgmt_fw_cmd_info {
> +	struct be_cmd_req_hdr hdr;
> +	void   *pdata_buffer;
> +	unsigned int data_length;
> +} __packed;
> +
> +struct be_mgmt_fw_cmd_info_resp {
> +	struct be_cmd_resp_hdr hdr;
> +	void   *pdata_buffer;
> +	unsigned int data_length;
> +} __packed;
> +
> +

Did you meant to send another patch with this one or did you not mean to 
include the mgmt_fw code in here? be_mgmt_fw_cmd_info_resp is not used 
and be_mgmt_fw_cmd_info is used in mgmt_fw_cmd, but that function is 
never called.
