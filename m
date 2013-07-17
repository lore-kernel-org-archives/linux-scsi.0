From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 6/7] qla4xxx: Export more firmware info in sysfs
Date: Wed, 17 Jul 2013 11:44:54 -0600
Message-ID: <51E6D816.4000102@cs.wisc.edu>
References: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com> <1373286791-29659-7-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35104 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932858Ab3GQRpQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jul 2013 13:45:16 -0400
In-Reply-To: <1373286791-29659-7-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adheer.chandravanshi@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

On 07/08/2013 06:33 AM, adheer.chandravanshi@qlogic.com wrote:
>  static ssize_t
> @@ -181,8 +179,8 @@ qla4xxx_iscsi_version_show(struct device *dev, struct device_attribute *attr,
>  			   char *buf)
>  {
>  	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
> -	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->iscsi_major,
> -			ha->iscsi_minor);
> +	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->fw_info.iscsi_major,
> +			ha->fw_info.iscsi_minor);
>  }

Is this the same as the iscsi max and min from the iscsi spec? If so, it
should be a iscsi host setting.

