From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] scsi: megaraid_sas - add module param max_sectors,
 cmd_per_lun
Date: Fri, 14 Sep 2007 03:32:16 -0700
Message-ID: <20070914033216.858d12e0.akpm@linux-foundation.org>
References: <1189514073.6082.14.camel@dhcp-75-534.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33235 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753403AbXINKcX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2007 06:32:23 -0400
In-Reply-To: <1189514073.6082.14.camel@dhcp-75-534.se.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-box <bo.yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, sumant.patro@lsi.com

On Tue, 11 Sep 2007 08:34:33 -0400 linux-box <bo.yang@lsi.com> wrote:

> +	struct megasas_instance *instance =
> +				(struct megasas_instance *)host->hostdata;

y'know, if some brave soul were to write

static inline void *scsi_host_data(struct Scsi_Host *host)
{
	return (void *)host->hostdata;
}

we could remove about 100000000000 ugly casts from scsi.

Just a thought...

