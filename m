From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 5/7] Add support for configuring the VLAN on the adapter.
Date: Mon, 13 Aug 2012 14:01:32 -0500
Message-ID: <50294F0C.2080205@cs.wisc.edu>
References: <1ccc8229-524d-4778-823f-bab06ee80b10@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53951 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab2HMTBk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2012 15:01:40 -0400
In-Reply-To: <1ccc8229-524d-4778-823f-bab06ee80b10@exht1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john-n@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@Emulex.Com>

On 08/13/2012 05:30 AM, John Soni Jose wrote:
>  
> +/**
> +  * beiscsi_set_vlan_attrib : Set the VLAN priority
> +  *	@shost : Scsi_Host pointer for the function.

extra space.


> +	case ISCSI_NET_PARAM_VLAN_ID:
> +		if (if_info.vlan_priority == BEISCSI_VLAN_DISABLE)
> +			len = sprintf(buf, "\n");
> +		else
> +			len = sprintf(buf, "%d\n",
> +					(if_info.vlan_priority &
> +					 ISCSI_MAX_VLAN_ID));
> +		break;
> +	case ISCSI_NET_PARAM_VLAN_PRIORITY:
> +		if (if_info.vlan_priority == BEISCSI_VLAN_DISABLE)
> +			len = sprintf(buf, "\n");

If its disabled then return -EINVAL.
