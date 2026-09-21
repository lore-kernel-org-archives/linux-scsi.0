Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B5A351C34;
	Mon, 21 Sep 2026 14:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789999386; cv=none; b=gdr0Ii5182nlu116iZnKVtKmxBPMiTSP9SAo4hQwxftxT7nXqVNS3bBhJKTYYoHQe9hz1fl4ik94tWoTuRn6k4ivzbOnLgM4IO7NO2CJRXerL331juIXzquixIMylSfd6KVlAkHVHmyEkKCDphL23Q2OjuVmXvTgJCTbIvoBNls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789999386; c=relaxed/simple;
	bh=wvcVtNVHw0w89loJmyZoHAtimw2msTfW4eXm7/Yf2O4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FDw6m3ttcdkjnbwIZaPYb36gcxGfmsJfkKbWbjHEvRcsgybgX2CoLD61rv87h1BBavT7bq9lR4lYJXIFngHR+nQTYqi50es+iv/3v/UXfvvvZZw02PIG3CKPiW/AqfDNepU9QnFYiHK1k/k3b7pEzRmDKVyFBFyw2AjdHjkvTdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PH18mTLD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GgqVZvP9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rzufyGvI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TZexhXNd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PH18mTLD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GgqVZvP9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rzufyGvI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TZexhXNd"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8381A21CBF;
	Mon, 21 Sep 2026 14:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789999378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TYnLpBD6VChvMLhsnFkWnEOep75Cg9uT1zXGo8tzMGE=;
	b=PH18mTLDEuT+4jA3Dl5h3ire/PKuFISKuNdcAS15WL3ddw+w1gsaIjnnN46NlN32x0X2jk
	7MS3dmTP2fQEkgVEKFvRGUPnjJSzgMVuVGv0ACsaGTKcP3bbqjBOyznYfBWda5ItbkOTDk
	97MYbwxoEJL05+xZgJ7WvLHWqIweCn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789999378;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TYnLpBD6VChvMLhsnFkWnEOep75Cg9uT1zXGo8tzMGE=;
	b=GgqVZvP96goz2cebgwE/jL2gcKygLAvc/5QYuGVTSZOA4wJU2JgDb5QS0C3RjLQ8rB5QRy
	AtTJsEYEjamXucDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789999374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TYnLpBD6VChvMLhsnFkWnEOep75Cg9uT1zXGo8tzMGE=;
	b=rzufyGvIKnIDNJuR5oz617+wG9bsFIHx/C2XRInCCCce10uF/5C+0eJF919s4X0QZU9YQv
	tbbF3DDSz1AtIUFHM/o4KS0Cc6yz6jvsN1KLGabNMnQM4pxpJJy8BuHMhx+8f8tnC28V3C
	5cOJJIhMT6ZHRzJ/yeX26ooqoA3whwE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789999374;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TYnLpBD6VChvMLhsnFkWnEOep75Cg9uT1zXGo8tzMGE=;
	b=TZexhXNdyI06936j9G2ay4FWZ6UHFU/v2Add6yvw9gJbA0Dyy55IWxjjEXzi0kWm4KxrZO
	HDHSaORw0dkLX0Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 22903139E7;
	Mon, 21 Sep 2026 14:02:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JmiHOgw5sWrjJQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 21 Sep 2026 14:02:53 +0000
Message-ID: <ab97f32b-31dd-4975-a8b2-b445110ae3a9@suse.de>
Date: Mon, 21 Sep 2026 16:02:52 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] nvme: fcloop: Add set_marginal_rport to sysfs
To: Jesse Taube <jtaubepe@redhat.com>, linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Justin Tee <justin.tee@broadcom.com>,
 Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
 Paul Ely <paul.ely@broadcom.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 John Meneghini <jmeneghi@redhat.com>, Bryan Gurney <bgurney@redhat.com>,
 Chris Leech <cleech@redhat.com>, "Ewan D . Milne" <emilne@redhat.com>,
 shinichiro.kawasaki@wdc.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
References: <20260902200547.184734-1-jtaubepe@redhat.com>
 <20260902200547.184734-8-jtaubepe@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260902200547.184734-8-jtaubepe@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lwn.net,linuxfoundation.org,kernel.org,kernel.dk,lst.de,grimberg.me,broadcom.com,gmail.com,nvidia.com,hansenpartnership.com,oracle.com,marvell.com,redhat.com,wdc.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On 9/2/26 10:05 PM, Jesse Taube wrote:
> To allow testing of multipath failover, add a sysfs attribute to set a
> remote port as marginal. This will allow the fcloop LLDD to set the
> marginal flag on a remote port, simulating a marginal link.
> 
> Example:
> Turn on marginal for a remote port matching wwnn and wwpn:
> `echo 'wwnn=0x200000109b5f2956,wwpn=0x100000109b5f2956,marginal=1' >
> /sys/class/fcloop/ctl/set_marginal_rport`
> 
> Turn off marginal for a remote port matching wwnn and wwpn:
> `echo 'wwnn=0x200000109b5f2956,wwpn=0x100000109b5f2956,marginal=0' >
> /sys/class/fcloop/ctl/set_marginal_rport`
> 
> Suggested-by: John Meneghini <jmeneghi@redhat.com>
> Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
> V10 -> V1:
>   - New patch
> V1 -> V2:
>   - Fix reference count leak in error path
> ---
>   drivers/nvme/target/fcloop.c | 50 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 50 insertions(+)
> 
> diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
> index b63af3b643a6..9977c2a71bd5 100644
> --- a/drivers/nvme/target/fcloop.c
> +++ b/drivers/nvme/target/fcloop.c
> @@ -6,6 +6,7 @@
>   #include <linux/module.h>
>   #include <linux/parser.h>
>   #include <uapi/scsi/fc/fc_fs.h>
> +#include <uapi/scsi/fc/fc_els.h>
>   
>   #include "../host/nvme.h"
>   #include "../target/nvmet.h"
> @@ -21,6 +22,7 @@ enum {
>   	NVMF_OPT_FCADDR		= 1 << 3,
>   	NVMF_OPT_LPWWNN		= 1 << 4,
>   	NVMF_OPT_LPWWPN		= 1 << 5,
> +	NVMF_OPT_MARGINAL	= 1 << 6,
>   };
>   
>   struct fcloop_ctrl_options {
> @@ -31,6 +33,7 @@ struct fcloop_ctrl_options {
>   	u32			fcaddr;
>   	u64			lpwwnn;
>   	u64			lpwwpn;
> +	u32			marginal;
>   };
>   
>   static const match_table_t opt_tokens = {
> @@ -40,6 +43,7 @@ static const match_table_t opt_tokens = {
>   	{ NVMF_OPT_FCADDR,	"fcaddr=%x"	},
>   	{ NVMF_OPT_LPWWNN,	"lpwwnn=%s"	},
>   	{ NVMF_OPT_LPWWPN,	"lpwwpn=%s"	},
> +	{ NVMF_OPT_MARGINAL,	"marginal=%d"	},
>   	{ NVMF_OPT_ERR,		NULL		}
>   };
>   
> @@ -120,6 +124,13 @@ fcloop_parse_options(struct fcloop_ctrl_options *opts,
>   			}
>   			opts->lpwwpn = token64;
>   			break;
> +		case NVMF_OPT_MARGINAL:
> +			if (match_int(args, &token)) {
> +				ret = -EINVAL;
> +				goto out_free_options;
> +			}
> +			opts->marginal = token;
> +			break;
>   		default:
>   			pr_warn("unknown parameter or missing value '%s'\n", p);
>   			ret = -EINVAL;
> @@ -199,6 +210,9 @@ fcloop_parse_nm_options(struct device *dev, u64 *nname, u64 *pname,
>   
>   #define TGTPORT_OPTS	(NVMF_OPT_WWNN | NVMF_OPT_WWPN)
>   
> +#define MARGINAL_OPTS	(NVMF_OPT_WWNN | NVMF_OPT_WWPN | \
> +			 NVMF_OPT_MARGINAL)
> +
>   
>   static DEFINE_SPINLOCK(fcloop_lock);
>   static LIST_HEAD(fcloop_lports);
> @@ -1663,6 +1677,40 @@ fcloop_set_cmd_drop(struct device *dev, struct device_attribute *attr,
>   	return count;
>   }
>   
> +static ssize_t
> +fcloop_set_marginal_rport(struct device *dev, struct device_attribute *attr,
> +		const char *buf, size_t count)
> +{
> +	struct fcloop_nport *nport;
> +	struct fcloop_ctrl_options opts = {};
> +	unsigned long flags;
> +	int ret;
> +
> +	ret = fcloop_parse_options(&opts, buf);
> +	if (ret)
> +		return ret;
> +
> +	/* everything there ? */
> +	if ((opts.mask & MARGINAL_OPTS) != MARGINAL_OPTS)
> +		return -EINVAL;
> +
> +	nport = fcloop_nport_lookup(opts.wwnn, opts.wwpn);
> +	if (!nport)
> +		return -ENOENT;
> +
> +	spin_lock_irqsave(&fcloop_lock, flags);
> +	if (!nport->rport || !nport->rport->remoteport) {
> +		spin_unlock_irqrestore(&fcloop_lock, flags);
> +		fcloop_nport_put(nport);
> +		return -ENOENT;
> +	}
> +
> +	nvme_fc_set_remoteport_fpin(nport->rport->remoteport, opts.marginal);
> +	spin_unlock_irqrestore(&fcloop_lock, flags);
> +	fcloop_nport_put(nport);
> +
> +	return count;
> +}
>   
>   static DEVICE_ATTR(add_local_port, 0200, NULL, fcloop_create_local_port);
>   static DEVICE_ATTR(del_local_port, 0200, NULL, fcloop_delete_local_port);
> @@ -1671,6 +1719,7 @@ static DEVICE_ATTR(del_remote_port, 0200, NULL, fcloop_delete_remote_port);
>   static DEVICE_ATTR(add_target_port, 0200, NULL, fcloop_create_target_port);
>   static DEVICE_ATTR(del_target_port, 0200, NULL, fcloop_delete_target_port);
>   static DEVICE_ATTR(set_cmd_drop, 0200, NULL, fcloop_set_cmd_drop);
> +static DEVICE_ATTR(set_marginal_rport, 0200, NULL, fcloop_set_marginal_rport);
>   
>   static struct attribute *fcloop_dev_attrs[] = {
>   	&dev_attr_add_local_port.attr,
> @@ -1680,6 +1729,7 @@ static struct attribute *fcloop_dev_attrs[] = {
>   	&dev_attr_add_target_port.attr,
>   	&dev_attr_del_target_port.attr,
>   	&dev_attr_set_cmd_drop.attr,
> +	&dev_attr_set_marginal_rport.attr,
>   	NULL
>   };
>   
Please don't make it a fabrics option. Setting is via sysfs is 
sufficient seeing it's for testing only.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
