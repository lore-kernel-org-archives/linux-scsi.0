From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/3] be2iscsi: Fixing the number of SGE's
Date: Thu, 07 Jan 2010 13:57:35 -0600
Message-ID: <4B463CAF.7030501@cs.wisc.edu>
References: <20100106221032.6104c233@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48334 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab0AGT5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jan 2010 14:57:44 -0500
In-Reply-To: <20100106221032.6104c233@mailhost.serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 01/06/2010 04:10 PM, Jayamohan Kalickal wrote:
> It is used in be_main.c (num_sge_per_io).
>
> The FW expects and sglist with 32 SGE's but 2 are used internally.
>

My fault. Patches look ok to me.
