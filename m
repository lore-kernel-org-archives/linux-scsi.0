From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/7] Issue MBX Cmd for login to boot target in crashdump
 mode
Date: Mon, 13 Aug 2012 13:52:42 -0500
Message-ID: <50294CFA.1060004@cs.wisc.edu>
References: <7012c437-3ab4-4cbb-9ecc-555d2fbf0df6@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53934 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab2HMSxH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2012 14:53:07 -0400
In-Reply-To: <7012c437-3ab4-4cbb-9ecc-555d2fbf0df6@exht1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john-n@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@Emulex.Com>

On 08/13/2012 05:29 AM, John Soni Jose wrote:
>  When the driver comes up in crashdump mode, it has to explicitly
>  issue command to FW for logging to the boot target. This fix issues
>  MBX Cmd to login to boot target in crashdump mode.
> 
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>


Could you fix the whitespace/tabs so they match the rest of the driver?


> + * beiscsi_get_boot_info : Get the boot session info

Driver does "-". I think for proper docbook style for functions we are
supposed to do "() -", but just - is ok for now, until we come alone and
fix them all.


> + * @phba : the device priv structure instance.

No space after phba. Check other places.

> +unsigned int mgmt_reopen_session(struct beiscsi_hba *phba,
> +		unsigned int reopen_type, unsigned int sess_handle)


Need some tabs. Check other places.

> +/**
> +  * be_mgmt_get_boot_shandle : Get the session handle for
> +  *							   boot session.

Not sure what happened with that second line.

